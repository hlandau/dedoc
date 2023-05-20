## METHOD: xhtml-single-xsl1
###############################################################################
#!priority=10
METHOD_XHTML_SINGLE_XSL1_DIR=$(DEDOC_BASE)/methods/xhtml-single-xsl1/
METHOD_XHTML_SINGLE_XSL1_XSL=$(METHOD_XHTML_SINGLE_XSL1_DIR)/dedoc-xhtml.xsl
METHOD_XHTML_SINGLE_XSL1_CSS=$(METHOD_XHTML_SINGLE_XSL1_DIR)/dedoc-xhtml.css

DOC_XHTML=$(BUILD_DIR)/out/$(DOCNAME).xhtml-single/index.xhtml
DOC_XHTML_PRETTY=$(BUILD_DIR)/out/$(DOCNAME).xhtml-single/index.pretty.xhtml

.PHONY: method_xhtml-single-xsl1_all

method_xhtml-single-xsl1_all: $(DOC_XHTML_PRETTY)

$(DOC_XHTML): $(METHOD_XHTML_SINGLE_XSL1_XSL) $(DOC_XML)
	$(call INFO,XSLTPROC,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(XSLTPROC) "$(METHOD_XHTML_SINGLE_XSL1_XSL)" "$(DOC_XML)" > "$@.tmp"
	$(Q)ln -f "$(METHOD_XHTML_SINGLE_XSL1_CSS)" "$(BUILD_DIR)/out/$(DOCNAME).xhtml-single/$(shell basename "$(METHOD_XHTML_SINGLE_XSL1_CSS)")"
	$(Q)mv "$@.tmp" "$@"

$(DOC_XHTML_PRETTY): $(DOC_XHTML)
	$(call INFO,PRETTY,$@)
	$(Q)$(XMLLINT) --pretty 2 --nsclean "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"
