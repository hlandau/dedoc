(define-module (dd-doc))
(use-modules (dedoc))

(define-public (top)
  (doc
    (docctl
      (title "Document with embedded manpages"))
    (docbody
      (sec "Section Title"
        (p "This is a paragraph in a section.")
        (p "Note that this section contains two subsections which are marked
            as embedded manpages. These will be extracted automatically
            for the purposes of producing manpages using mdoc.")
        `(sec (@ (man-section 1)
                 (man-os "dedoc")
                 (man-volume-title "DEDOC Examples"))
              (hdr (title "mandoc"))
                (p "This is a paragraph in a section.")
                (p "This is a paragraph in a section."))
        `(sec (@ (man-section 2)
                 (man-os "dedoc")
                 (man-volume-title "DEDOC Examples"))
              (hdr (title "somecall"))
                (p "This is a paragraph in a section.")
                (p "This is a paragraph in a section."))))))
