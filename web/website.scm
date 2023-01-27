#!/bin/sh
set -e; exec guile --fresh-auto-compile --no-auto-compile -L "$(dirname "$0")" -L ../schema -s "$0" "$@" #!#
;; vim: filetype=scheme fdm=marker
(define-module (website))
(use-modules (ice-9 match) (ice-9 ftw) (sxml2))

;; Main Document                                                            {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-public ns-xhtml "http://www.w3.org/1999/xhtml")

(define _DEDOC "DEDOC")
(define _dedoc `(tt "dedoc"))

(define* (page-layout #:key
                      (title "DEDOC")
                      (body '()))
  `(*TOP*
     (html (@ (@ (*NAMESPACES* (*IMPLICIT* ,ns-xhtml    *IMPLICIT*)))
              (lang en) (xml:lang en))
           (head
             (meta (@ (http-equiv "Content-Type") (content "application/xhtml+xml; charset=utf-8")))
             (meta (@ (http-equiv "X-UA-Compatible") (content "IE=edge")))
             (meta (@ (name "viewport") (content "width=device-width,initial-scale=1")))
             (title ,title)
             (link (@ (rel stylesheet) (href "dedoc-website.css"))))
           (body
             (div (@ (class main-wrap))
               (nav (@ (class top-nav))
                 (ul (@ (class rhs))
                   (li (a (@ (href "#") (class cross-slash-icon-link)) (span) "Hugo Landau")))
                 (ul (@ (class lhs))
                   (li (a (@ (href ".") (class logotext)) "DEDOC"))
                   (li (a (@ (href "schema/")) "Schema Definition"))
                   (li (a (@ (href "samples")) "Examples"))
                   (li (a (@ (href "tutorial")) "Getting Started"))
                   (li (a (@ (href "https://github.com/hlandau/dedoc")) "Source"))))
               (div (@ (class swipe-reminder) (hidden ""))
                    (p "⇒ Swipe right for navigation ⇒"))
               (div (@ (class prealign))
                    (h1 (@ (class logo-img))
                        "DEDOC"))
               (main
                 (article (@ (class has-logo))
                    ,@body))

               (footer (ul
                  (li (@ (class nodot))
                      (a (@ (class cross-slash-icon-link)
                            (href "https://www.devever.net/~hl/")) (span) "Hugo Landau")))))))))

;; DEDOC
;;   Index
;;      DEDOC is a ...
;;   Schema Documentation
;;   Samples
;;   Source


(define (intro)
  `((p "DEDOC is two things:")
    (ul
      (li (p ,_DEDOC", an XML schema for writing high-quality technical documentation
              while targeting multiple different output formats, including
              XHTML, PDF, EPUB and plain text;"))
      (li (p ,_dedoc", an environment for writing technical documentation in Scheme
              targeting the "DEDOC" schema.")))
    (p "In short, ",_dedoc" is a system for writing natural-language technical
        documents using Scheme. By using the power of S-expressions, including
        ordinary functions, macros and backquoting, and SXML (the
        representation of XML in S-expressions), you can ergonomically write
        documents which compile to highly semantic, clean XML in whatever schema
        you desire.")

    (p "You can then use the power of SXML (or, if you wish, any external XML
        manipulation tooling of your choice, such as an XSLT processor) to “lower”
        this highly semantic and platonic XML representation of your document into
        a more concrete representation, such as DocBook, XHTML or XSL-FO;
        or you can use a Scheme transformer which consumes your SXML and
        produces a non-XML representation such as LaTeX or ConTeXt.")

    (p "The purpose of ",_DEDOC" is to allow the production of technical documents
        which can be consumed as XHTML and come across as documents which were
        designed for optimal consumption as XHTML; "(em "and")" which can be
        consumed as PDFs and come across as documents which were designed for optimal
        consumption as PDFs. In other words, ",_DEDOC" seeks to avoid any compromise
        as to the quality of the output.")

    (p "Because ",_DEDOC" documents are literally written in a full Scheme environment,
        the system is also optimally suited to generating documents with large amounts
        of generated content; for example, register manuals. You can use Scheme to
        import arbitrary machine-readable data from any source and trivially transform
        it into SXML. Moreover, since DEDOC can be used to produce high-quality,
        semantic XML documents, those resulting documents are easily machine-read to
        extract the embedded information. Why have people read through a 10,000 page
        PDF of registers, when you can provide them with an XML file which
        is both viewable in a web browser and machine intelligible, allowing
        automated processing of all register definitions? You can either use XHTML
        directly with embedded domain-specific semantic annotations, or a domain-specific
        XML representation which is rendered viewable in a web browser via an attached
        XSLT or CSS stylesheet.")

     (p "Though ",_DEDOC" is the reference schema for ",_dedoc", it can also be used
         with any other schema, such as a schema of your own definition.")

     (p ,_dedoc" is tiny. The core of it is a very small amount of ergonomic glue
        built on top of SXML. You can consider it a demonstration of the power
        of Scheme.")

     (p "Because documents are written in Scheme, you can ergonomically reference other objects
         inline in text via lexical references. For example:")

     (pre ";; Define a term. This can be referenced lexically. All terms are collated
;; in a list inside the Scheme environment, and can be mapped over
;; programmatically to automatically populate a Definitions section in the
;; output. The use of lexical referencees to terms ensures integrity of
;; references and allows the output to contain hyperlinks to definitions, etc.
(dt table \"table\" \"A table is a surface on which objects can be placed.\")

;; Define a proword. This is similar to a term but it is usually used
;; to express a normative requirement. RFCs have prowords such as
;; MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. ISO standards have
;; prowords such as \"shall\", \"shall not\", etc.
(dpword must \"MUST\")

;; Paragraph referencing the term \"table\" and the proword \"MUST\" lexically.
;; Note that the quotes around \"table\" and \"MUST\" here are actually ending a
;; quoted-string then beginning a new one; Scheme does not require any spaces here.
;; Simply make your eyes forget you're in a quoted string, and accept the convention
;; of placing terms and prowords in quotes to refer to them. It's surprisingly ergonomic.
(p \"A \"table\" \"MUST\" have four legs.\")")

      (p "Note that this is not a special parsing environment. "(tt "dt")", "(tt "dpword")" and "(tt "p")"
          are simply Scheme macros or functions which define items in the
          Scheme lexical environment. The full power of Scheme can be used to
          produce generated output. A ",_dedoc" document is simply a Scheme
          program which, when executed, outputs XML.")

      (p ,_dedoc" is intended to be used with Guile Scheme, though it's possible
         it could be ported to other Schemes.")
        ))

(define-public (web-index)
  (page-layout #:title "DEDOC Document Engineering Language" #:body `(
    (h1 "DEDOC Document Engineering Language")
    ,(intro))))

(define (tutorial)
  `((p "...")))

(define-public (web-tutorial)
  (page-layout #:title "DEDOC Tutorial" #:body `(
    (h1 "DEDOC Tutorial")
    ,(tutorial))))

(define (example-names)
  (filter (lambda (x) (not (string-prefix? "." x))) (scandir "../examples/")))

(define example-descriptions
  `(("001-simple" . ("Simple example of generating ",_DEDOC" output."))))

(define (examples)
  `(table
     (tr (th "Name") (th "Description"))
     ,(map (lambda (example-name)
             `(tr (td (a (@ (href ,(format #f "~a" example-name))) ,example-name)) (td ,(assoc-ref example-descriptions example-name))))
           (example-names))))

(define-public (web-examples)
  (page-layout #:title "DEDOC Examples" #:body `(
    (h1 "DEDOC Examples")
    ,(examples))))


;; Generation and Output                                                    {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (pages)
  `((index . ,(web-index))
    (tutorial . ,(web-tutorial))
    (examples . ,(web-examples))))

(define (write-page slug sxml)
  (call-with-output-file (format #f "build/out/~s.xhtml" slug) (lambda (output-port)
    (with-output-to-port output-port (lambda () (sxml->xml sxml))))))

(define (write-all-pages)
  (for-each (lambda (page) (write-page (car page) (cdr page))) (pages)))

;; If this file is being executed directly, generate the pages.
(when (eq? autoloads-in-progress '())
  (write-all-pages))
