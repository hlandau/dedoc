#!/bin/sh
set -e; exec guile --fresh-auto-compile --no-auto-compile -L "$(dirname "$0")" -s "$0" "$@" #!#
;; vim: filetype=scheme fdm=marker
(define-module (dedoc))
(use-modules (ice-9 match) (sxml2))

;; Main Document                                                            {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (_title) "The DevEver Documentation and Specification Language (DEDOC)")

;; Namespace definitions
(define-public ns-dedoc   "https://www.devever.net/ns/dedoc")
(define-public ns-xhtml   "http://www.w3.org/1999/xhtml")
(define-public ns-xlink   "http://www.w3.org/1999/xlink")
(define-public ns-mml     "http://www.w3.org/1998/Math/MathML")
(define-public ns-rddl    "http://www.rddl.org/")
(define-public ns-relaxng "http://relaxng.org/ns/structure/1.0")
(define-public ns-xsd     "http://www.w3.org/2001/XMLSchema-datatypes")

;; RNG: define a choice between various elements
(define (defchoice name choices)
  `(r:define (@ (name ,name))
             (r:choice ,@(map rref choices))))

;; RNG: define an element
(define (defelem name . body)
  `(r:define (@ (name ,name))
             (r:element (@ (name ,name))
                        ,@body)))

;; RNG: reference another definition
(define (rref name)
  `(r:ref (@ (name ,name))))

;; RNG: zero or more of...
(define (zeroOrMore . args)
  `(r:zeroOrMore ,@args))

;; RNG: optional
(define (optional . args)
  `(r:optional ,@args))

;; RNG: interleave
(define (interleave . args)
  `(r:interleave ,@args))

;; The DEDOC specification document with embedded RNG definitions.
(define (document) `(
  (h1 ,(_title))
  (section (@ (id intro)) (h2 "Introduction")
    (p "This document specifies the DevEver Documentation and Specification Language (DEDOC). DEDOC is an XML schema and markup language intended for the specification of technical specifications, standards and documentation. For more information on DEDOC and its supporting tooling, see "(a (@ (href "https://www.devever.net/~hl/dedoc/")) "the DEDOC website."))
    (p (strong "How DEDOC is specified.") " Note that this specification is itself written as a Guile Scheme program, which, when executed, outputs XHTML with embedded RELAX NG schema definitions. Thus, this document is both human and machine-readable. Generally, the RELAX NG schema will be automatically extracted from this document to facilitate its further use for validation purposes.")
    (p "Because the RELAX NG schema is written as part of this document, this document is the canonical source for the RELAX NG schema definitions for DEDOC. Thus, this document constitutes the normative specification for DEDOC for the purposes of both human-readable and machine-readable expressions.")
    (p "Moreover, the expression of DEDOC herein, in which narrative is interweaved with RELAX NG definitions shown inline, constitutes an application of “literate programming” methodology to XML schema definition. This is directly inspired by other attempts to both apply literate programming to XML schema definition while simultaneously having a single source of truth for schema definition, most notably TEI's “One Document Does It All” (TEI ODD) model.")
    (p "The choice of XHTML as the schema for this document was made to avoid circular dependencies on DEDOC.")
    (p (strong "Purposes of DEDOC.") " DEDOC is intended to support writing documentation once and producing multiple production quality output formats, including:")
    (ul
      (li "XHTML (multiple pages);")
      (li "XHTML (single page);")
      (li "EPUB;")
      (li "PDF via ConTeXt XML, for the highest quality typesetting for print output;")
      (li "PDF via XSL-FO (low-quality output; ConTeXt preferred);")
      (li "man pages (in mdoc format); and")
      (li "plain text (RFC-style)."))
    (p "There exists an existing XML-based markup language, namely DocBook, which aims to cover much of this
        ground, but DocBook suffers from several issues:")
    (ul
      (li "it is an expansive and extremely complex taxonomy, with a massive number of features unlikely to be fully supported by any given transformation toolchain;")
      (li "the available open source tooling for typesetting DocBook into print cannot produce output of as high a quality as TeX can (for production typesetting, commercially available XSL-FO implementations such as Antenna House's appear to be used);")
      (li "DEDOC aims to have better support for the high-fidelity yet ergonomic expression of figures and diagrams."))

    (p "When designing a universal source format for documentation which aims to target the production of multiple output forms, the means by which diagrams are to be expressed becomes a potentially complicated question. In particular:")
    (ul
      (li "production-quality PDF outputs require diagrams be incorporated in vector (PDF) form for acceptable quality;")
      (li "modern XHTML outputs require diagrams in SVG form if they are to be resolution-independent;")
      (li "older web or EPUB devices might require diagrams be provided in raster (e.g. PNG) form."))

    (p "What complicates this matter further is that diagrams may contain text. Where a specific typesetting
        system is used such as TeX, it is likely to be jarring if text in a diagram is rendered differently
        to the main body text, as there can be distinctive differences in rendering. Conversely, if a diagram
        has its text typeset in TeX, because the diagram was generate via TeX, it may be jarring for such a
        diagram to appear inside a web page.")

    (p "Thus, the following determinations are made:")

    (ul
      (li (p "Firstly, that it may be inevitably necessary for different input representations to be used
           for generation of different output formats. For example, a diagram might be provided as two
           files, one to be used for XHTML output and one to be used for PDF output.")
           (p "This is not constrained to just diagrams. For example, a piece of mathematics might need
              to be expressed both as TeX code (for use when generating PDF output) and as MathML code
              (for web use). (Though ConTeXt does support MathML input, it is anticipated that there will
              be cases where its MathML support is inadequate for complex formulas.)")
           (p "Thus a general solution of "(em "forks")" is adopted. A fork is a construct inside a DEDOC
               document whereby a processor consuming a DEDOC document chooses exactly one of the forks,
               and is free to choose the fork most appropriate to it. For example, a math formula might
               be expressed in a fork containing both MathML and TeX representations, or a diagram might
               be expressed in a fork containing SVG, PDF and PNG representations."))

      (li (p "Secondly, support for diagrams receive specific attention. A diagram is essentially expressed
              as a fork (though it may be a degenerate fork containing only one representation). Diagrams
              may be expressed in a variety of formats, such as external SVG, PDF or raster files,
              or as some kind of program or program fragment which, when executed, generates the desired
              diagram. An example of the latter is the TikZ DSL for drawing diagrams which has been implemented on top of TeX, but there are also countless other examples of non-TeX programs which are designed to consume some kind of textual input and generate diagrammatic outputs, such as Asymptote. This constitutes a very convenient and time-saving way for developers to express (and version control) diagrams which might otherwise
              have to be created manually inside a graphical editor and versioned as opaque binary files created
              by graphical editing tools.")
            (p "A diagram fork thus specifies one or more representations; each representation specifies its format, and either its text or a filename containing the representation data. If multiple representations are provided, an output generator is free to choose the one best suited to its output format.")
            (p "In some cases, the desired output format may be especially “aligned” with a provided representation. For example, if a diagram is provided as TikZ code, and the output is being produced using a TeX processor, rather than generating the diagram as a vector file and embedding it, the TikZ code can be directly executed inside the TeX environment during the typesetting process. This has the advantage that the diagram inherits any font and other settings applied to the TeX document and thus matches the look and feel of the rest of the output as closely as possible.")
            (p "In other cases, the only provided representations may be “unaligned”. If the provided representation is a raster or vector image, it is simply included directly. Another example of an unaligned representation is TikZ input code where the desired output is XHTML; in this case, TeX must be invoked for each such diagram to produce SVG output for that diagram alone. Compare this with when TeX is being used for typesetting, where the TikZ code is simply included into the document and does not result in a separate invocation of TeX. This process should be managed automatically, so that TikZ can be used to generate diagrams for both XHTML and TeX (PDF) output methods.")
            (p "Numerous other text-input diagram generators are available and it is anticipated that these
                will generally require the invocation of some external program for both the TeX and XHTML output
                pathways; thus the diagram support in DEDOC must be extensible to arbitrary external processing tools.")
            (p "Although diagrams are modelled as forks and thus can have an author write or provide multiple input representations if truly necessary to maintain acceptable fidelity across all output formats, it is anticipated that in the majority of cases it will be possible to generate acceptable quality diagrams from a single source and DEDOC focuses on ensuring that this is the case."))))

  (section (@ (id schema-res)) (h2 "Schema Resources")
           (p "The namespace URI for DEDOC is “"(code ,ns-dedoc)"”.")
           (p "Where used, namespace prefixes in this document refer to the following namespaces:")
           (pre (@ (class rng-prologue))
"namespace mml = \"http://www.w3.org/1998/Math/MathML\"
namespace xlink = \"http://www.w3.org/1999/xlink\"
namespace bib = "https://www.devever.net/ns/bib"
namespace local = \"\"
datatypes xsd = \"http://www.w3.org/2001/XMLSchema-datatypes\"")
           (p "This page is RDDL-enabled. The following schema artifacts generated from this document are available:")
           (ul
             (li (rddl:resource
                   (@ (xlink:role "http://relaxng.org/ns/structure/1.0")
                      (xlink:arcrole "http://www.rddl.org/purposes#schema-validation")
                      (xlink:href "dedoc.rng")
                      (xlink:title "RELAX NG schema"))
                   (a (@ (href "dedoc.rng")) "RELAX NG schema for this namespace")))
             (li (rddl:resource
                   (@ (xlink:role "http://www.isi.edu/in-notes/iana/assignments/media-types/application/relax-ng-compact-syntax")
                      (xlink:arcrole "http://www.rddl.org/purposes#schema-validation")
                      (xlink:href "dedoc.rnc")
                      (xlink:title "RELAX NG compact schema"))
                   (a (@ (href "dedoc.rnc")) "RELAX NG compact schema for this namespace")))
             )
           (p "For more information on the tooling surrounding DEDOC, see "(a (@ (href "https://www.devever.net/~hl/dedoc/"))"the DEDOC website."))
           )

  (section (@ (id overall)) (h2 "Overall Structure")
           (p "The DEDOC language is composed of three layers:")
           (ul
             (li "inline-level constructs, the lowest layer;")
             (li "block-level constructs;")
             (li "structural constructs, the highest layer."))
           (p "Inline constructs contain text and other inline constructs, block-level constructs contain other block constructs and inline constructs, and structural constructs contain other structural constructs or block-level constructs. Inline constructs are constructs which occur inside a single paragraph and often tend to relate to the horizontal formatting of text. Block constructs include the paragraph (p) element and other constructs and tend to relate to the vertical layout of text. Structural constructs group blocks and create a hierarchical logical document structure.")
           (p "The remainder of this document introduces the three layers, starting with the lowest layer and building upwards.")
           (p "The root element is "(code 'doc)":")
           (r:start ,(rref 'doc))
           )

  (section (@ (id structural)) (h2 "Structural Constructs")

           (section (h3 "doc")
                    (p "An entire document.")

                    ,(defelem 'doc
                              (rref 'universal-attributes)
                              (rref 'docctl)
                              (rref 'docbody)
                              ))

           (section (h3 "docctl")
                    (p "The control information comprises metadata which does not appear in the document body itself, and which should not necessarily be rendered.")
                    ,(defelem 'docctl
                              (interleave
                                (rref 'title)
                                (optional (rref 'buildinfo)))))

           (section (h3 "buildinfo")
                    (p "Contains information about a build process which produced a DEDOC XML file.")
                    ,(defelem 'buildinfo
                              (interleave
                                (rref 'vcsrevsummary)
                                (optional (rref 'vcsrev))
                                (optional (rref 'vcstime)))))

           (section (h3 "vcsrevsummary")
                     (p "Contains a single-line VCS revision summary. The "(tt "form")" attribute indicates whether a full or abbreviated revision summary is used. For example, a short VCS revision summary might contain only a few hexadecimal characters to cryptographically identify the revision, whereas the long summary may contain the full hash. Note that there is no set form for either of these strings and they are not required to contain only hexadecimal characters.")
                     (r:define (@ (name "vcsrevsummary"))
                               (r:interleave (r:optional ,(rref 'vcsrevsummary.long))
                                             (r:optional ,(rref 'vcsrevsummary.short))))
                     (r:define (@ (name "vcsrevsummary.long"))
                               (r:element (@ (name vcsrevsummary))
                                          (r:attribute (@ (name "form")) (r:value "long"))
                                          (r:text)))
                     (r:define (@ (name "vcsrevsummary.short"))
                               (r:element (@ (name vcsrevsummary))
                                          (r:attribute (@ (name "form")) (r:value "short"))
                                          (r:text))))

           (section (h3 "vcsrev")
                    (p "Contains a full-length cryptographic identifier for the VCS revision from which the DEDOC XML file was built. If the VCS being used does not have a suitable cryptographic identifier, the best available unambiguous identifier should be used. A "(tt "+")" should be appended if the tree was 'dirty' when building, meaning that changes may have been made since the referenced revision.")
                    ,(defelem 'vcsrev `(r:text)))

           (section (h3 "vcstime")
                    (p "Contains a timestamp for the VCS revision from which the DEDOC XML file was built.")
                    ,(defelem 'vcstime `(r:data (@ (type dateTime)))))

           (section (h3 "docbody")
                    (p "The document body contains structural constructs.")
                    ,(defelem 'docbody (zeroOrMore `(r:choice ,(rref 'sec)))))

           (section (h3 "sec")
                    (p "A section. Sections may begin with some block-level constructs which are not in a section, but block-level constructs directly within a given section may not come after a subsection of that section. Sections nest infinitely, but specific output systems may have limits on the depth supported.")

                    ,(defelem 'sec
                              (rref 'universal-attributes)
                              `(r:optional (r:attribute (@ (name man-section)) (r:text)))
                              `(r:optional (r:attribute (@ (name man-os)) (r:text)))
                              `(r:optional (r:attribute (@ (name man-volume-title)) (r:text)))
                              `(r:optional (r:attribute (@ (name secno)) (r:text)))
                              (rref 'titledHdr)
                              (zeroOrMore (rref 'BLOCK))
                              (zeroOrMore (rref 'sec)))
                    )

           (section (h3 "titledHdr")
                    (p "Container of header and metadata information for structural (and formal float) constructs which have a title.")

                    (r:define (@ (name titledHdr))
                               (r:element (@ (name hdr))
                                          (r:optional ,(rref 'secno))
                                          ,(rref 'lint)
                                          ,(rref 'title)))

                    )

           (section (h3 "title")
                    (p "The title of a structural construct, such as a section or document.")
                    ,(defelem 'title
                              `(r:text)))

           (section (h3 "secno")
                    (p "The number of a section.")
                    ,(defelem 'secno `(r:text)))

           )

  (section (@ (id block)) (h2 "Block Constructs")
    (p "Block constructs contain other block constructs, inline constructs or text, and generally relate to the vertical layout of text in a document.")

    ,(defchoice 'BLOCK '(p LIST FORMAL_FLOAT ESCAPE VERBATIM)) ;; TODO dia

    (section (h3 "Paragraphs")
             (p "Denotes a paragraph, which constains only inline constructs and which is the most commonly used construct to place inline constructs in a block construct environment.")
             ,(defelem 'p (zeroOrMore (rref 'INLINE)))
             )

    (section (h3 "Lists")
             ,(defchoice 'LIST '(ul ol dict))

             (section (h4 "ul")
                      (p "An unordered list. May contain only <li> elements, which constitute the elements of the list.")
                      ,(defelem 'ul (zeroOrMore (rref 'li)))
                      )
             (section (h4 "ol")
                      (p "An ordered list. May contain only <li> elements, which constitute the elements of the list.")
                      ,(defelem 'ol (zeroOrMore (rref 'li))))
             (section (h4 "li")
                      (p "A list item in an ordered or unordered list.")
                      ,(defelem 'li (zeroOrMore (rref 'BLOCK))))

             (section (h4 "dict")
                      (p "A dictionary list, which maps keys to values.")
                      ,(defelem 'dict (zeroOrMore (rref 'dice))))
             (section (h4 "dice")
                      (p "A dictionary list item.")
                      ,(defelem 'dice (rref 'dick) (rref 'dicb)))
             (section (h4 "dick")
                      (p "The key of a dictionary list item.")
                      ,(defelem 'dick (zeroOrMore (rref 'INLINE))))
             (section (h4 "dicb")
                      (p "The body of a dictionary list item.")
                      ,(defelem 'dicb (zeroOrMore (rref 'BLOCK))))
             )

    (section (h3 "Formal Floats")
             (p "Formal floats are numbered containers such as “figures” and “tables”. These form separate numbering namespaces independent of section numbering. They do not necessarily contain actual tables.")

             ,(defchoice 'FORMAL_FLOAT '(figure table equation))

             (section (h4 "figure")
                      (p "A figure is a formal float numbered with a prefix word “Figure”. They are generally to be used to show diagrams but need not be. They contain block constructs.")
                      ,(defelem 'figure
                                (rref 'titledHdr)
                                (zeroOrMore (rref 'BLOCK))))
             (section (h4 "table")
                      (p "A table is a formal float numbered with a prefix word “Table”. They are generally to be used to show diagrams but need not be. They contain block constructs.")
                      ,(defelem 'table
                                (rref 'titledHdr)
                                (zeroOrMore (rref 'BLOCK))))
             (section (h4 "equation")
                      (p "An equation is a formal float. They are used for display math and contain math code directly; they cannot be used for other purposes. This is a forking construct.")
                      ,(defelem 'equation
                                `(r:optional ,(rref 'tex))
                                `(r:optional ,(rref 'mmlmath)))))

    (section (h3 "Verbatims")
             (p "Verbatims are blocks of text which are laid out in monospaced, verbatim form with no elision of spaces. They are typically used for displaying source code fragments. Note that unlike e.g. LaTeX verbatims, they can contain other markup.")

             ,(defchoice 'VERBATIM '(listing))

             (section (h4 "listing")
               (p "A generic code listing verbatim. This should be your default choice of verbatim if in doubt.")
               ,(defelem 'listing
                         `(r:zeroOrMore ,(rref 'INLINE))))

             )

    (section (h3 "Diagrams")
             (p "TODO"))
           )

  (section (@ (id inline)) (h2 "Inline Constructs")
    (p "Inline constructs contain text and other inline constructs, and generally relate to the horizontal formatting of text within a given paragraph.")

    (r:define (@ (name INLINE)) (r:choice
                                  (r:text)
                                  ,(rref 'SEMANTIC_PHRASE)
                                  ,(rref 'MATH_INLINE)
                                  ,(rref 'BREAKOUT)
                                  ,(rref 'REFERENCE)
                                  ,(rref 'NONSEMANTIC_INLINE)
                                  ,(rref 'ESCAPE)))

    (section (h3 "Semantic Phrases")
             (p "“Semantic phrases” refers to one or a few words which should be annotated with their semantic meaning so that they can sometimes be specially typeset. Examples of “semantic phrases” that appear in many manuals are typed commands, class names, RFC 2119 keywords, etc.")
             ,(defchoice 'SEMANTIC_PHRASE '(proword procn kw))

             (section (h4 "proword")
                      (p "A proword is a word or phrase with normative power in the context of a standard or specification. Examples include RFC 2119 capitalized words in RFCs, and the phrases “shall”, “shall not”, “should”, “should not”, “may”, “may not”, “must” and “must not” in ISO standards.")
                      ,(defelem 'proword (zeroOrMore (rref 'INLINE))))

             (section (h4 "procn")
                      (p "A procedure name. Used to refer to a procedure by name in prose.")
                      ,(defelem 'procn (zeroOrMore (rref 'INLINE))))

             (section (h4 "kw")
                      (p "A keyword. Usually typeset in monospace.")
                      ,(defelem 'kw (zeroOrMore (rref 'INLINE))))

             )

    (section (h3 "Mathematics")

             ,(defchoice 'MATH_INLINE '(math))

             (section (h4 "math")
                      (p "Inline mathematics. This is also a fork construct, and can therefore contain multiple representations of the same mathematics.")
                      ,(defelem 'math
                                `(r:optional ,(rref 'tex))
                                `(r:optional ,(rref 'mmlmath)))
                      (r:define (@ (name mmlmath))
                                (r:element
                                  (r:name (@ (ns ,ns-mml)) math)
                                  (r:attribute (r:anyName) (r:text))
                                  (r:zeroOrMore (r:choice ,(rref 'mmlany) (r:text)))))

                      (r:define (@ (name mmlany))
                        (r:element (r:nsName (@ (ns ,ns-mml)))
                                   (r:attribute (r:anyName) (r:text))
                                   (r:zeroOrMore
                                     (r:choice
                                       (r:element
                                         (r:nsName (@ (ns ,ns-mml)))
                                         (r:zeroOrMore ,(rref 'mmlany)))
                                       (r:text)))))))

    (section (h3 "Breakouts")
             (p "A breakout is a construct which is considered a block, and which can contain blocks, yet which is allowed to appear in an inline context.")

             ,(defchoice 'BREAKOUT '(footnote))

             (section (h4 "footnote")
                      (p "A footnote defined inline. A footnote contains block constructs.")
                      ,(defelem 'footnote
                                `(r:optional (r:attribute (@ (name label)) (r:text)))
                                (zeroOrMore (rref 'BLOCK)))))

    (section (h3 "Cross-Referencing")
      (p "Inline constructs which reference other documents, or other constructs in the same document. Some of these are also considered semantic phrases.")

      ,(defchoice 'REFERENCE '(term link cite))

      (section (h4 "term")
        (p "Use a term in prose which was previously defined. Use to properly reference the item of terminology at its definition site.")
        (p "The optional attribute “sp” specifies whether this use of the term is singular or plural.")
        ,(defelem 'term
               `(r:attribute (r:name (@ (ns ,ns-xlink)) href) (r:data (@ (type anyURI))))
               `(r:optional (r:attribute (@ (name sp)) (r:choice (r:value "singular") (r:value "plural") )))
               (zeroOrMore (rref 'INLINE))
               ))

      (section (h4 "link")
        (p "Inline reference to another construct in the same or another document, generating a hyperlink where possible. The text is manually specified.")
        ,(defelem 'link
                  `(r:attribute (r:name (@ (ns ,ns-xlink)) href) (r:data (@ (type anyURI))))
                  (zeroOrMore (rref 'INLINE))
                  ))

      (section (h4 "cite")
        (p "Inline citation. This differs from link in that the text of the hyperlink is generated automatically.")
        ,(defelem 'cite
                  `(r:attribute (r:name (@ (ns ,ns-xlink)) href) (r:data (@ (type anyURI)))))))

    (section (h3 "Nonsemantic Formatting")
      (p "Though discouraged, some elements are defined which can be used to express a specific typesetting
          request. This should only be done if no alternatives are suitable.")

      ,(defchoice 'NONSEMANTIC_INLINE '(em tt))
      (section (h4 "em")
        (p "Request emphasis (generally represented as italics). Avoid where possible.")
        ,(defelem 'em (zeroOrMore (rref 'INLINE))))
      (section (h4 "tt")
        (p "Request typesetting in monospace. Avoid using this if an appropriate semantic phrase element is available.")
        ,(defelem 'tt (zeroOrMore (rref 'INLINE))))))

  (section (@ (id escape)) (h2 "Escape Hatches")
           (p "Provides constructs which should not be used unless absolutely necessary, because they expose the semantics of underlying typesetting systems.")
           ,(defchoice 'ESCAPE '(tex))

           (section (h3 "TeX")
                    (p "TeX passthrough. The TeX code specified is executed. For non-TeX output, this element and its contents are removed and ignored.")
             ,(defelem 'tex
                       `(r:text))))

  (section (@ (id misc-def)) (h2 "Miscellaneous Definitions")
           (section (h3 "Universal Attributes")
                    (r:define (@ (name universal-attributes))
                              (r:zeroOrMore
                                (r:choice
                                  ,(rref 'foreign-attribute)
                                  )))

                    (r:define (@ (name foreign-attribute))
                              (r:attribute (r:anyName (r:except (r:choice (r:nsName (@ (ns ""))) (r:nsName (@ (ns ,ns-dedoc)))))) (r:text) ))
                    )
           (section (h3 "Lint")
                    (p "Lint is semantically meaningless text wrapped in an element designating it as such. It is usually used to contain spacing or punctuation between other things.")
                    (r:define (@ (name lint))
                              (r:optional (r:element (@ (name lint)) (r:text))))))))


;; XHTML Wrapping for DEDOC Specification                                   {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-public dedoc-specification
  `(*TOP*
     (html (@ (@ (*NAMESPACES* (*IMPLICIT* ,ns-xhtml     *IMPLICIT*)
                               (rddl       ,ns-rddl      rddl)
                               (d          ,ns-dedoc     d)
                               (xlink      ,ns-xlink     xlink)
                               (r          ,ns-relaxng   r)
                               (xsd        ,ns-xsd       xsd)))
              (lang en) (xml:lang en))
           (head
             (meta (@ (http-equiv "Content-Type") (content "application/xhtml+xml; charset=utf-8")))
             (link (@ (rel stylesheet) (href "dedoc.css")))
             (title ,(_title))
             )
           (body ,@(document)))))


;; DEDOC Support Utilities                                                  {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; These are utilities not used to produce the DEDOC document itself but which
;; are useful shortcuts for DEDOC documents importing this module for the
;; purposes of writing DEDOC documents.

;; Helper for defining a section.
;;
;; (sec title:sxml body:sxml...) → sxml
(define-public (sec title . xs) `(sec (hdr (title ,title)) ,@xs))

;; Helper for defining a figure with a given title and body.
;;
;; (figure title:sxml body:sxml...) → sxml
(define-public (figure title . xs) `(figure (hdr (title ,title)) ,@xs))

;; Helper for VCS tagging.
;;
;; (vcsrevsummary.long/short summary:str) → sxml
(define-public (vcsrevsummary.long summary) `(vcsrevsummary (@ (form "long")) summary))
(define-public (vcsrevsummary.short summary) `(vcsrevsummary (@ (form "short")) summary))

;; Generates the desired top-level structure for a DEDOC document.
;;
;; (doc body:sxml...) → sxml
(define-public (doc . xs) `(*TOP* (doc (@ (@ (*NAMESPACES* (*IMPLICIT* ,ns-dedoc *IMPLICIT*)
                                                           (h          ,ns-xhtml h)
                                                           (m          ,ns-mml   m)
                                                           (xlink      ,ns-xlink xlink)))
                                                           (xml:lang en)) ,@xs)))

;; Easily tag an element with an XML ID.
;;
;; (with-id id:symbol element:sxml-element) → sxml
(define-public (with-id id x) (sxml-with-attribute x 'xml:id id))


;; DEDOC Support Utilities: Postprocessing                                  {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Postprocessing phases which transform the SXML of a DEDOC document.
;;
;; The currently defined postprocessing phases are:
;;
;;   - clause numbering, in which section/clause numbers are added as metadata
;;     to the SXML representation.
;;
;; Of course, since SXML is easy to work with, a DEDOC document source file is
;; free to apply its own transforms as well.
;;
;; (postprocess document:sxml-top) → sxml-top
(define-public (postprocess doc) (add-vcs-info (number-clauses doc)))


;; DEDOC Support Utilities: Postprocessing: VCS Information                 {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This adds Git revision information to a DEDOC document if available.

(define (make-buildinfo)
  (let ((short (getenv "GITINFO_SHORT"))
        (long  (getenv "GITINFO_LONG"))
        (rev   (getenv "GITINFO_REV"))
        (time  (getenv "GITINFO_TIME")))
  `(buildinfo
     ,(if (not (eq? "" short)) `(vcsrevsummary (@ (form short)) ,short) "")
     ,(if (not (eq? "" long))  `(vcsrevsummary (@ (form long)) ,long) "")
     ,(if (not (eq? "" rev))   `(vcsrev ,rev) "")
     ,(if (not (eq? "" time))  `(vcstime ,time) ""))))

(define* (add-vcs-info s)
     (match s
            (('docctl . xs)
             (cons 'docctl (cons (make-buildinfo) xs)))
            (((? symbol? s) . xs)
             (cons s (map add-vcs-info xs)))
            (_ s)))


;; DEDOC Support Utilities: Postprocessing: Section Numbering               {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This provides a postprocessing phase for DEDOC documents, causing section
;; numbers to be correctly added as metadata to the SXML representation.

;; (number-clauses document:sxml-top) → sxml-top
(define number-clauses ((lambda ()
  (define (step-context-element elem is-annex?)
    (if (not is-annex?) (1+ elem)
        (if (number? elem) #\A (integer->char (1+ (char->integer elem))))))

  (define (step-context ctx is-annex?)
    (match ctx
           ((x . xs)
            (cons (step-context-element x is-annex?) xs))
           (_ (error (list "cannot step" ctx)))))

  (define (enter-context ctx)
    (cons 0 ctx))

  (define (output-context ctx)
    (string-join (map (lambda (e)
                        (cond
                          ((number? e) (number->string e))
                          ((char? e) (string e))
                          ((string? e) e)))
                      (reverse ctx)) "."))

  (define* (number-clauses s #:optional (ctx '(0)))
    (match s
           (( ((and sym (or 'sec)) ('@ . attrs) ('hdr ('title t)) . xs) . ys)
            (let* ((is-annex? (eq? sym 'annex))
                   (new-ctx (step-context ctx is-annex?))
                   (number (output-context new-ctx)))
              `((,sym (@ (secno ,number) . ,attrs)
                     (hdr
                       (secno ,number)
                       (lint ". ")
                       (title ,t))
                 ,@(number-clauses xs (enter-context new-ctx)))
                . ,(number-clauses ys new-ctx))))
          (( ((and sym (or 'sec)) ('hdr ('title t)) . xs) . ys) ;; TODO deduplicate this
            (let* ((is-annex? (eq? sym 'annex))
                   (new-ctx (step-context ctx is-annex?))
                   (number (output-context new-ctx)))
              `((,sym (@ (secno ,number))
                     (hdr
                       (secno ,number)
                       (lint ". ")
                       (title ,t))
                 ,@(number-clauses xs (enter-context new-ctx)))
                . ,(number-clauses ys new-ctx))))
           (( ((? symbol? h) . xs) . ys)
            (cons (cons h (number-clauses xs ctx))
                  (number-clauses ys ctx)))
           (((? symbol? x) . xs)
            (cons x
                  (number-clauses xs ctx)))
           (("" . xs)
            (number-clauses xs ctx))
           (_ s)))

  number-clauses)))


;; Schema Autoreflection Utilities                                          {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define a Scheme function for a given DEDOC XML element.
(define (define-elem pfx name)
  (when (not (defined? name)) (begin
    (primitive-eval `(define (,name . xs) (cons ',name xs)))
    (primitive-eval `(export ,name)))))

;; Automatically create Scheme functions based on reflecting RNG definitions in
;; a SXML document. If a helper has already been manually defined, it is not
;; overridden. This allows helpers to be customised where appropriate.
(define (create-bindings pfx doc)
  (let rec ((d doc))
    (match d
      (('*TOP* . xs) (map rec xs))
      (('@ . xs) #f)
      (('r:define ('@ . as) (and relem ('r:element . xs)))
        (let ((elem-name (sxml-attribute 'name relem)))
          (when elem-name
            (define-elem pfx (car elem-name)))))
      (((? symbol? name) . xs) (map rec xs))
      ((? string? s) #f)
      ((? symbol? s) #f)
      (_ (error (list "?" d))))))


;; Generation and Output                                                    {{{1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Create Scheme bindings which automatically reflect the RNG definitions which are
;; embedded inline in the above DEDOC specification.
(create-bindings #f dedoc-specification)

;; If this file is being executed directly, output the DEDOC spec.
(when (eq? autoloads-in-progress '())
  (sxml->xml dedoc-specification))
