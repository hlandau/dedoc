#!/bin/sh
set -e; exec guile --fresh-auto-compile --no-auto-compile -L "$(dirname "$0")" -L ../schema -s "$0" "$@" #!#
;; vim: filetype=scheme fdm=marker
(define-module (website))
(use-modules (ice-9 match) (ice-9 ftw) (sxml2))

;; Main Document                                                            {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-public ns-xhtml "http://www.w3.org/1999/xhtml")

(define _DEDOC "DEDOC")
(define _dedoc "dedoc")
(define _dedoc.scm `(tt "dedoc.scm"))
(define _dedoc-methods `(tt "dedoc-methods"))
(define _acmetool `(a (@ (href "https://www.devever.net/~hl/acmetool/")) "acmetool"))
(define _context "ConTeXt")

(define* (page-layout #:key
                      (title _dedoc)
                      (logo #f)
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
                   (li (a (@ (href "https://www.devever.net/~hl/") (class cross-slash-icon-link)) (span) "Hugo Landau")))
                 (ul (@ (class lhs))
                   (li (a (@ (href ".") (class logotext)) "dedoc"))
                   (li (a (@ (href ".")) "Home"))
                   (li (a (@ (href "schema/")) "Schema Definition"))
                   (li (a (@ (href "examples")) "Examples"))
                   (li (a (@ (href "tutorial")) "Getting Started"))
                   (li (a (@ (href "https://github.com/hlandau/dedoc")) "Source"))))
               (div (@ (class swipe-reminder) (hidden ""))
                    (p "⇒ Swipe right for navigation ⇒"))
               ,(if logo `(div (@ (class prealign))
                    (h1 (@ (class logo-img))
                        "dedoc")) "")
               (main
                 (article (@ (class has-logo))
                    ,@body))

               (footer (ul
                  ,(let ((git-short (getenv "GITINFO_SHORT"))
                        (git-long (getenv "GITINFO_LONG")))
                     (if git-short `(li (@ (title ,(or git-long ""))) ,git-short) ""))
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
  `(
    (p ,_dedoc" is a system for writing natural-language technical
       documentation or technical standards which focuses on providing a
       powerful writing environment while refusing to compromise on quality of
       output.")

    (p ,_dedoc" as a whole comprises three fundamental parts:")
    (ul
      (li (p ,_DEDOC", an "(a (@ (href "schema/")) "XML schema")" for writing high-quality technical documentation
              while targeting multiple different output formats, including
              XHTML, EPUB, man pages and plain text, while also being simpler and
              more focused than DocBook;"))
      (li (p ,_dedoc.scm", an environment for writing technical documentation in Scheme
              targeting the "DEDOC" schema, providing a friendlier writing
              environment for hypertext than writing XML directly and allowing
              procedural generation of content using arbitrary Scheme code;"))
      (li (p ,_dedoc-methods", a set of Makefile-driven methods for converting ",_DEDOC" files to various output formats,
              such as XHTML, EPUB, plain text and man pages.")))

    (p (strong "Scheme writing environment. ") "In short, ",_dedoc" is a system
       for writing natural-language technical documents using Scheme. By using
       the power of S-expressions, including ordinary functions, macros and
       backquoting, and SXML (the representation of XML in S-expressions), you
       can ergonomically write documents which compile to a highly semantic,
       clean XML representation:")

    (pre "\
(define (introduction)
  (sec \"Introduction\"
       (p \"This is an example of writing a DEDOC section with a single
            paragraph. We can also procedurally generate content:\")

       (map (lambda (name)
              (p \"This is \"name\"'s paragraph.\"))
            (list \"Alice\" \"Bob\" \"Charlie\"))

       (p \"p is just a function which simply provides a convenience for
            writing SXML. We can also write SXML directly using
            quasiquotation:\")

       `(p (@ (class \"the-answer\"))
           \"The answer to life, the universe, and everything is \"
           ,(* 6 7) \".\")

        )))")

    (p (strong "Internal and external transformation. ")"You can then use the
       power of SXML (or, if you wish, any external XML manipulation tooling of
                          your choice, such as an XSLT processor) to “lower”
       this semantic, platonic XML representation of your document into a more
       concrete representation, such as DocBook, XHTML or XSL-FO; or you can
       use a Scheme transformer which consumes your SXML and produces a non-XML
       representation such as LaTeX, ConTeXt or roff. You can also use Scheme
       or external processing tools to transform the (S)XML document prior to
       lowering, for example by automatically adding section numbering, tables
       of contents or similar, or by compiling figure images from their source
       representation.")

    (p (strong "High quality output. ")"The purpose of ",_dedoc" is to allow
       the production of technical documents which can be consumed as XHTML and
       come across as documents which were designed for optimal consumption as
       XHTML; "(em "and")" which can be consumed as PDFs and come across as
       documents which were designed for optimal consumption as PDFs. In other
       words, ",_dedoc" seeks to avoid any compromise as to the quality of the
       output. This remains a work in progress, mainly due to the lack of any
       open-source PDF typesetting solution which can produce an acceptable
       quality of output in an unattended manner; thus PDF output is not yet
       available.")

    (p (strong "Machine generation and readability. ") "Because documents are
       literally written in a full Scheme environment, the system is also
       optimally suited to generating documents with large amounts of generated
       content; for example, register manuals. You can use Scheme to import
       arbitrary machine-readable data from any source and trivially transform
       it into SXML. Moreover, since ",_dedoc" can be used to produce
       high-quality, semantic XML documents, those resulting documents are
       easily machine-read to extract the embedded information. Why have people
       read through a 10,000 page PDF of registers, when you can provide them
       with an XML file which is both viewable in a web browser and machine
       intelligible, allowing automated processing of all register definitions?
       You can either use XHTML directly with embedded domain-specific semantic
       annotations, or a domain-specific XML representation which is rendered
       viewable in a web browser via an attached XSLT or CSS stylesheet.")

     (p (strong "Generalisable to other schemas. ") "Though ",_DEDOC" is the
        reference schema for ",_dedoc", the principles used are fully generalisable
        and ",_dedoc.scm" amounts to little more than a handful of utility functions
        and macros to make writing SXML slightly more ergonomic. Thus, the entire
        system could be readily adapted to use with any other schema.")

     (p (strong "Small size. ") ,_dedoc" is tiny. The core of it is a very
        small amount of ergonomic glue which simply makes writing SXML for the
        target schema (",_DEDOC") slightly easier. You can consider it a
        demonstration of the power of Scheme.")

     (p (strong "Checked lexical references. ") "Because documents are written
        in Scheme, you can ergonomically reference other objects inline in text
        via lexical references. For example, when using ",_DEDOC", terminology
        (as might be found in a definitions section of a specification) is
        defined like so:")

     (pre ";; Define a term. This can be referenced lexically. All terms are collated
;; in a list inside the Scheme environment, and can be mapped over
;; programmatically to automatically populate a Definitions section in the
;; output. The use of lexical references to terms ensures integrity of
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
          Scheme lexical environment.")

      (p "In the example above, "(tt "table")" and "(tt "MUST")" are simply
         lexical references in the Scheme environment to objects which have
         been defined in that environment via the previous "(tt "dt")" and "(tt
         "dpword")" macro invocations.")
      (p "Note that unlike some other languages, Scheme
         does not require you to place spaces between quoted strings and other
         tokens. This allows you to form the habit of simply putting all terminology
         in quotes to reference it (a style which is reminiscent of that used by
         some contract lawyers when referencing terminology). Although in actuality
         what you're doing here is ending a string constant, referencing an object
         and then starting a new string constant, it's easy to localise your
         vision to make your eyes “forget” this and act as though you're
         actually opening and closing a semantic construct, rather than closing
         and opening one.")

      (p (strong "Scheme runtime environment. ")"The full power of Scheme can be used to
         produce generated output. A ",_dedoc" document is simply a Scheme
         program which, when executed, outputs XML.")

      (p ,_dedoc" is intended to be used with Guile Scheme, though it's possible
         it could be ported to other Schemes.")

      (p (strong ,_dedoc-methods ". ") ,_dedoc" comes with a collection of
         typesetting methods known as ",_dedoc-methods". Methods are split into different
         tiers depending on the priority they are given in terms of support and maintenance.
         The highest tier is Tier 1, which includes:")

      (ul
        (li (tt "xhtml-single-xsl1")", which produces a single XHTML file
            from ",_DEDOC" XML using an XSLT1 transform. Uses "(tt "xsltproc")".")
        (li (tt "epub-xsl1")", which produces an EPUB file from ",_DEDOC" XML
            using the "(tt "xhtml-single-xsl1")" method and a subsequent
            transform. Requires "(tt "zip")".")
        (li (tt "mdoc-xsl1")", which produces a "(tt "mdoc")"-format roff-style file
            from ",_DEDOC" XML using an XSLT1-based transform. Requires "(tt
            "xsltproc")" and XMLStarlet."))

      (p "Tier 2 currently includes:")

      (ul
        (li (tt "txt-mandoc-mdoc-xsl1")", an example of generating plain text
            (tier 1), PostScript, PDF or XHTML (tier 2"(sup †)") output using the "(tt
            "mandoc(1)")" program.")
        (li (tt "txt-roff-mdoc-xsl1")", an example of generating plain
            text (tier 1), PostScript, PDF or XHTML (tier 2"(sup †)") output using the
            "(tt "groff(1)")" program."))

      (p (sup †)"The "(tt "mandoc(1)")" and "(tt "groff(1)")" workflows are primarily intended
          to be used for their plain text output. Since they are also capable of producing
          PostScript, PDF and (X)HTML output, this functionality is also exposed for
          demonstration purposes, however this output will not be as high quality as
          the dedicated methods above.")

      (p (strong "Current usage. "),_dedoc" is used to produce the documentation for ",_acmetool".")
      (p "To get started, try the "(a (@ (href "tutorial")) "tutorial")" or examine some of the "(a (@ (href "examples")) "example documents.")" For a more elaborate example of ",_dedoc"'s output, see the "(a (@ (href "https://www.devever.net/~hl/acmetool/")) ,_acmetool" manual."))))

(define-public (web-index)
  (let ((title (string-append "The "_dedoc" Document Engineering Environment")))
    (page-layout #:title title #:logo #t #:body `((h1 ,title) ,(intro)))))

(define (tutorial)
  `((p "To get started with "_dedoc" begin by cloning the repsitory:")
    (pre "$ git clone https://github.com/hlandau/dedoc")
    (p (strong "Dependencies. ")"You will need to have the following tools available in your environment:")
    (ul
      (li "GNU Guile Scheme ("(tt "guile(1)")") (required);")
      (li "GNU Make v4.4 or later ("(tt "make(1)")") (required) — "(strong "note")" that this is very new and your distro may not have it yet;")
      (li (tt "xmllint(1)")" (strongly recommended and assumed);")
      (li (tt "xsltproc(1)")" (strongly recommended and assumed);")
      (li (tt "rnv(1)")" (strongly recommended and assumed);"))
    (p "Specific output methods may require additional tools:")
    (ul
      (li (tt "xml(1)")", provided by XMLStartlet (for mdoc output and transforms dependent on it);")
      (li (tt "zip(1)")" (for EPUB support);")
      (li (tt "groff(1)")" (for groff-based transformations);")
      (li (tt "mandoc(1)")" (for mandoc-based transformations);")
      (li "Python 3 with the packages "(tt "lxml")" and "(tt "html5_parser")" (for mandoc-based XHTML output).")
      )
    (p "On NixOS, you can get a shell with all the needed dependencies using the following command, though you will need to be using "(tt "nixpkgs")" 23.05 or newer, or unstable:")
    (pre "\
$ nix-shell -p guile libxml2 libxslt rnv xmlstarlet zip groff \\
    mandoc gnumake 'python3.withPackages(p: [p.lxml p.html5-parser])'
")
    (p (strong "Basic usage. ")"To compile a document using ",_dedoc", run the "(tt "bin/dedoc")" command while in the directory
        containing a "(tt "dd-*.scm")" file; alternatively, run "(tt "bin/dedoc -C <dir>")", where
        "(tt "<dir>")" is the directory containing the "(tt "dd-*.scm")" file. Output will be produced in the "(tt "build/")" directory.")
    (p "For example, create an empty directory "(tt "tutorial-1")" and place a file named "(tt "dd-tutorial-1.scm")" in it:")
    (pre "\
(define-module (dd-tutorial-1))
(use-modules (dedoc))

(define-public (top)
  (doc
    (docctl (title \"Tutorial 1\"))
    (docbody
      (sec \"Section Title\"
        (p \"This is a paragraph.\")))))\
")

    (p "(You can find more information on the ",_DEDOC" schema in the "(a (@ (href "schema/")) ,_DEDOC" schema specification.")")")

    (p "Now run "(tt "$DEDOC/bin/dedoc")" from that directory, where "(tt "$DEDOC")" is the path
       you cloned the ",_dedoc" repository to. The output will be produced in the "(tt "build/")" directory.")

    (p (strong "Note: ") "By default, ",_dedoc" uses the "(tt "dd-*.scm")"
       naming convention to automatically detect which file in a directory is
       the ",_dedoc.scm" file containing your document source. If you have
       multiple files of the form "(tt "dd-*.scm")" in a directory, you will
       need to specify the correct file manually by customising the Makefile
       options (see below).")
    (p (strong "Shell shortcut. ") (tt "mk/dedoc-shell.sh")" is a file you can optionally source into your shell to setup
       an alias for the "(tt "dedoc(1)")" command, sparing you from needing to type the full
       path to "(tt "bin/dedoc")" every time:")
    (pre "\
$ cd some-document/
$ ls
dd-some-document.scm
$ . ~/path/to/dedoc-checkout/mk/dedoc-shell.sh
$ dedoc")

    (p (strong "Makefile customisation. ") "The part of ",_dedoc" which actually transforms the output
       ",_DEDOC" XML file into useful output formats is known as the ",_dedoc-methods " collection.
       This is a Makefile-driven workflow in the UNIX tradition. The workflow has been organised
       in a highly modular way so that each possible output method has its own makefile in its own subdirectory of the "(tt "$DEDOC/methods")" directory. This is then tied together with a master makefile in the "(tt "$DEDOC/mk")" directory. In fact, invoking "(tt "dedoc(1)")" is actually just a shorthand for invoking GNU Make with this master makefile.")

    (p "You can customise the default settings of the various makefiles by creating a makefile named "(tt "Makefile.config")" in the same directory as your "(tt "dd-*.scm")" file. This is an optional file which, if present, GNU Make will source to allow you to override ",_dedoc-methods"'s default settings.")

    (p "The settings you can override include:")
    (dl
      (dt (tt "DOCNAME"))
      (dd (p "By default, ",_dedoc" automatically determines the filename of your document
              by looking for a file named in the pattern "(tt "dd-*.scm")". If you have
              more than one file named this way, this is ambiguous; alternatively, you may
              not wish to name your source files this way. In this case, you can set this
              to the source file name explicitly."))

      (dt (tt "BUILD_DIR"))
      (dd (p "The output build directory. Defaults to "(tt "build/")))
      (dt (tt "METHODS"))
      (dd (p "The list of method names to use when creating output files. You can use this
              to disable some methods or to add your own methods. By default, a reasonable
              default set of supported methods is listed.")))

    (p "The path to each program needed for the operation of ",_dedoc" can
        generally be overridden also; see "(tt "mk/support.mk")" for details.")

    (p "Each method may also have its own settings you can override. See the
       file named "(tt "method.mk")" in each method's directory in the
       ",_dedoc" source tree for details.")

    (p (strong "Makefile targets. ") "The following make targets are available:")
    (dl
      (dt (tt "all"))
      (dd (p "Build everything."))
      (dt (tt "clean"))
      (dd (p "Deletes the build output directory."))
      (dt (tt "method_NAME_all"))
      (dd (p "Builds all outputs defined by the method "(tt "NAME")"."))
      (dt (tt "build/"(em "DOCNAME")".xhtml")" (for example)")
      (dd (p "You can also instruct make to build a specific build output directly by naming the path of the file which would be produced."))
      )
))

(define-public (web-tutorial)
  (page-layout #:title (string-append _dedoc" Tutorial") #:body `(
    (h1 ,_dedoc" Tutorial")
    ,(tutorial))))

(define (example-names)
  (filter (lambda (x) (not (string-prefix? "." x))) (scandir "../examples/")))

(define example-descriptions
  `(("001-simple" #f ("Simple example of generating ",_DEDOC" output."))
    ("002-manpages" #t ("Example document which contains embedded man pages, which are automatically extracted and converted into actual man pages during the build process."))))

(define (output-links name)
  `(ul (@ (class "outputs")) ,@(map (lambda (k) `(li (a (@ (href ,(string-append "example-output/" name "/dd-doc" (car k)))) ,(cdr k)))) `(
    (".pretty.xml" . "DEDOC XML")
    (".xhtml-single" . "XHTML (single file)")
    (".epub" . "EPUB")
    ,@(if (car (assoc-ref example-descriptions name))
          '((".mdoc/" . "Man pages — mdoc")
            (".mdoc-mandoc-txt/" . "Man pages — TXT (mdoc/mandoc)")
            (".mdoc-roff-txt/" . "Man pages — TXT (mdoc/roff)")
            (".mdoc-roff-ptxt/" . "Man pages — TXT (Paginated) (mdoc/roff)"))
          '())))
       (li (a (@ (href ,(string-append "example-output/" name "/"))) "Other outputs"))))

(define (examples)
  `(table (@ (class "examples"))
     (tr (th "Name") (th "Description and Outputs"))
     ,(map (lambda (example-name)
             `(tr (td (a (@ (href ,(format #f "https://github.com/hlandau/dedoc/tree/master/examples/~a" example-name))) ,example-name)) (td ,(cdr (assoc-ref example-descriptions example-name))
                                                                                                                                                   ,(output-links example-name))))
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
