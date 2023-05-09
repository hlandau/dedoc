## METHOD: latexml-dedoc
###############################################################################
METHOD_LATEXML_DEDOC_DIR=$(DEDOC_BASE)/methods/latexml-dedoc/
METHOD_LATEXML_DEDOC_XSL=$(METHOD_LATEXML_DEDOC_DIR)/dedoc-dtexml-latex.xsl

DOC_LATEXML=$(BUILD_DIR)/out/$(DOCNAME).latexml
DOC_LATEXML_PRETTY=$(BUILD_DIR)/out/$(DOCNAME).pretty.latexml

.PHONY: method_latexml-dedoc_all

method_latexml-dedoc_all: $(DOC_LATEXML_PRETTY)

$(DOC_LATEXML): $(METHOD_LATEXML_DEDOC_XSL) $(DOC_XML)
	$(call INFO,XSLTPROC,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(XSLTPROC) "$(METHOD_LATEXML_DEDOC_XSL)" "$(DOC_XML)" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(DOC_LATEXML_PRETTY): $(DOC_LATEXML)
	$(call INFO,PRETTY,$@)
	$(Q)$(XMLLINT) --pretty 2 --nsclean "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"
