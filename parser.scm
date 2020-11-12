(module discounter (parse-request)
(import intarweb)
(import openssl)
(import http-client)
(import html-parser)
(import spiffy)
(import spiffy-uri-match)
(import uri-common)
(import srfi-1)
(import srfi-12)
(import srfi-13)
(import srfi-18)

(import posix-utils)
(import scheme)
(import medea)
(import (chicken base))
(import (chicken io))
(import (chicken string))
(import (prefix (parsers bookDepository) "bd:"))

(define port
  (let ((port-string (environment-variable-bound? "PORT")))
    (if (eq? #f port-string)
        8080
        (let ((port-number (string->number port-string)))
          (if (eq? #f port-number)
              8080
              port-number)))))

(define host
  (let ((host-string (environment-variable-bound? "HOST")))
    (if (eq? #f host-string)
        "localhost"
        host-string)))


(define (parse-request url owner)
  (let ((safe-owner (if (symbol? owner) owner (string->symbol owner))))
    (case safe-owner
      ('BookDepository (bd:parse url))
      (else (json->string `((status . "error")
                            (message . ,(string-append "Cannot parse owner with name: " (symbol->string safe-owner))))))))
  )
;(print (parse-request "aHR0cHM6Ly93d3cuYm9va2RlcG9zaXRvcnkuY29tL0JlZWtlZXBlci1BbGVwcG8tQ2hyaXN0eS1MZWZ0ZXJpLzk3ODE4Mzg3NzAwMTM/cmVmPXBkX2d3XzFfcGRfZ2F0ZXdheV8xXzE="  "BookDepository"))


(define app
  `(((/ "parseProduct")
     (GET , (lambda _
              (let* ((q (uri-query (request-uri (current-request))))
                     (url (alist-ref 'url q))
                     (owner (alist-ref 'owner q))
                     (parsed-request (parse-request url owner)))
                (send-response status: 'ok body: parsed-request)))))))

(define thread
  (thread-start! (lambda ()
                   (vhost-map `((".*". ,(uri-match/spiffy app))))
                   (start-server port: port bind-address: host))))

(thread-join! thread)

)
