## METHOD: pdf-latex-latexml-dedoc
###############################################################################
METHOD_PDF_LATEX_LATEXML_DEDOC_DIR=$(DEDOC_BASE)/methods/pdf-latex-latexml-dedoc/

DOC_PDF_LATEX=$(BUILD_DIR)/out/$(DOCNAME)-latex.pdf
DOC_PDF_LATEX_INT=$(BUILD_DIR)/int/$(DOCNAME).latex/$(DOCNAME).pdf

.PHONY: method_pdf-latex-latexml-dedoc_all

method_pdf-latex-latexml-dedoc_all: $(DOC_PDF_LATEX)

$(DOC_PDF_LATEX): $(DOC_PDF_LATEX_INT)
	$(Q)ln -f "$<" "$@"

$(DOC_PDF_LATEX_INT): $(DOC_LATEX)
	$(call INFO,LUALATEX,$@)
	$(Q)(cd "$$(dirname "$@")"; $(LUALATEX) $(LUALATEX_ARGS) "$$(basename "$<")";)
