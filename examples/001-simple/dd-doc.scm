(define-module (dd-doc))
(use-modules (dedoc))

(define-public (top)
  (doc
    (docctl
      (title "Simple Document"))
    (docbody
      (sec "Section Title"
           (p "This is a paragraph in a section.")
           (p "This is a paragraph in a section.")))))
