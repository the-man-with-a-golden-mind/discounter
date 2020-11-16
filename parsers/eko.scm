module (parsers eko) (parse parse-db)
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
(import srfi-63)
(import (chicken base))
(import (chicken io))
(import (chicken string))

(define clean-other-names
  (lambda (on)
    (begin
      (map (lambda (elem) (second elem)) (cdr on)))
    ))

(define pase->json

  )

(define parse
  (lambda (url)
    (handle-exceptions exn
      (begin
        (print exn)
        (json->string `((status . "error")
                        (message . ,(string-append "can not parse url: " url)))))
      (let* ((html-content (with-input-from-request url #f html->sxml))
             (substance-name ((sxpath "//td[@class='column-1']/text()") html-content))
             (substance-name-json (map (lambda (elem) (cons 'name elem)) substance-name))
             (other-names  ((sxpath "//td[@class='column-2']/ul") html-content))
             (other-names-cleaned (map (lambda (elem) (clean-other-names elem)) other-names))
             (other-names-cleaned-json (map (lambda (elem) (cons 'othernames (list->vector elem))) other-names-cleaned))
             (substance-function ((sxpath "//td[@class='column-3']/p/text()") html-content))
             (substance-function-json (map (lambda (elem) (cons 'function_name elem)) substance-function))
             (definition ((sxpath "//td[@class='column-4']/p/text()") html-content))
             (definition-json (cons 'def definition))
             (issues ((sxpath "//td[@class='column-5']/p/text()") html-content))
             (issues-json (cons 'issues issues))
             (zipped-data (zip substance-name-json other-names-cleaned-json substance-function-json definition-json issues-json))
             )
        
        (begin
          (print (first zipped-data))
          (json->string `((status . "ok")
                          (data . ,substance-name-json)))))
      )))


(parse "https://piggypeg.pl/lista-substancji/")


