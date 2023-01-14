(define-module (dd-doc))
(use-modules (dedoc))

(define-public (top)
  (doc
    (docctl
      (title "Specimen 001")
      )
    (docbody
      (sec "Section Title"
           (p "This is a paragraph in a section.")
           (p "This is a paragraph in a section."))

      `(sec (@ (man-section 1)) (hdr (title "mandoc"))
              (p "This is a paragraph in a section.")
              (p "This is a paragraph in a section."))
      `(sec (@ (man-section 2)) (hdr (title "somecall"))
              (p "This is a paragraph in a section.")
              (p "This is a paragraph in a section."))

      )))
