## METHOD: fo-xsl1
###############################################################################
METHOD_FO_XSL1_DIR=$(DEDOC_BASE)/methods/fo-xsl1/
METHOD_FO_XSL1_XSL=$(METHOD_FO_XSL1_DIR)/dedoc-fo.xsl

DOC_FO=$(BUILD_DIR)/out/$(DOCNAME).fo
DOC_FO_PRETTY=$(BUILD_DIR)/out/$(DOCNAME).pretty.fo

.PHONY: method_fo-xsl1_all

method_fo-xsl1_all: $(DOC_FO_PRETTY)

$(DOC_FO): $(METHOD_FO_XSL1_XSL) $(DOC_XML)
	$(call INFO,XSLTPROC,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(XSLTPROC) "$(METHOD_FO_XSL1_XSL)" "$(DOC_XML)" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(DOC_FO_PRETTY): $(DOC_FO)
	$(call INFO,PRETTY,$@)
	$(Q)$(XMLLINT) --pretty 2 --nsclean "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"
