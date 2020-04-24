(module (parsers bookDepository) (parse)
(import scheme)
(import srfi-1)
(import srfi-12)
(import srfi-13)
(import sxpath)
(import (clojurian syntax))
(import sxpath-lolevel)
(import html-parser)
(import http-client)
(import medea)
(import base64)
(import (chicken base))
(import (chicken io))
(import (chicken string))

(define parse-price
  (lambda (some-price) (if (not (equal? some-price ""))
                 (-> some-price
                     (string-split " ")
                     (cadr))
                 some-price)))

(define (parse-currency price)
  (if (not (equal? price ""))
      (-> price
          (string-split " ")
          (car)
          (substring 1 3)
          (string-upcase))
      price))


(define (decode-url url)
  (base64-decode url))

(define parse
  (lambda (url)
    (handle-exceptions exn
      (json->string `((status . "error")
                      (message . ,(string-append "can not parse url: " url))))
      (let* ((decoded-url (decode-url url))
             (html-content (with-input-from-request decoded-url #f html->sxml))
             (sale-price ((sxpath "string(//span[@class='sale-price']/text())" ) html-content))
             (book-image ((sxpath "string(//img[@class='book-img']//@src)") html-content))
             (parsed-sale-price (parse-price sale-price))
             (main-price ((sxpath "string(//span[@class='list-price']/text())") html-content))
             (parsed-main-price (parse-price main-price))
             (price-currency (parse-currency sale-price))
             (product-name ((sxpath "string(//h1[@itemprop='name']/text())") html-content)))
       (json->string `((status . "ok")
                       (data . ((currency . ,price-currency)
                                (image . ,book-image)
                                (name . ,product-name)
                                (discountPrice . ,parsed-sale-price)
                                (price . ,(if (equal? parsed-main-price "") parsed-sale-price parsed-main-price))))))))))

;(print (parse "aHR0cHM6Ly93d3cuYm9va2RlcG9zaXRvcnkuY29tL0JlZWtlZXBlci1BbGVwcG8tQ2hyaXN0eS1MZWZ0ZXJpLzk3ODE4Mzg3NzAwMTM/cmVmPXBkX2d3XzFfcGRfZ2F0ZXdheV8xXzE="))

)
