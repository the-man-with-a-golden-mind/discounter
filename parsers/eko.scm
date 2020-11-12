(module (parsers eko) (parse)
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
(import (chicken base))
(import (chicken io))
(import (chicken string))

(define parse
  (lambda (url)
    (handle-exceptions exn
      (begin
        (json->string `((status . "error")
                        (message . ,(string-append "can not parse url: " url)))))
      (let* ((html-content (with-input-from-request url #f html->sxml))
             (substance-name ((sxpath "string(//td[@class='column-1']/text())") html-content))
             (other-names  ((sxpath "string(//td[@class='column-2']/text())") html-content)))
        (json->string `((status . "ok")
                        (data . ((name . ,substance-name)
                                 (otherNames . ,other-names)))))
        ))))

(parse "https://piggypeg.pl/lista-substancji/")

)
