(import  srfi-12
         html-parser
         spiffy-uri-match
         srfi-1
         srfi-13
         http-client
         srfi-18
         spiffy
         intarweb
         uri-common
         (chicken io)
         (chicken string))

(define GOOGLE-CLIENT-ID "118954669613-n5nae0tff6do6puqdefccquqffn10ivo.apps.googleusercontent.com")
(define GOOGLE-CLIENT-SECRET "ElGiAboNx2VY4kfqjZPIABu0")

(define app
  `(((/ "getProducts")
    (GET , (lambda _
             (let* ((q (uri-query (request-uri (current-request))))
                   ;(url (alist-ref 'url q))
                                        ;(parsed-url (parse-content url))
                   )
              (send-response status: 'ok body: parsed-url)))))))

(vhost-map `((".*". ,(uri-match/spiffy app))))

(start-server port: 8080 bind-address: "192.168.8.127")
