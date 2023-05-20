## METHOD: epub-xsl1
###############################################################################
#!priority=20
METHOD_EPUB_XSL1_DIR=$(DEDOC_BASE)/methods/epub-xsl1/
METHOD_EPUB_XSL1_SCRIPT=$(METHOD_EPUB_XSL1_DIR)/gen-epub

DOC_EPUB=$(BUILD_DIR)/out/$(DOCNAME).epub

.PHONY: method_epub-xsl1_all

method_epub-xsl1_all: $(DOC_EPUB)

$(DOC_EPUB): $(DOC_XHTML) $(METHOD_EPUB_XSL1_SCRIPT)
	$(call INFO,GEN-EPUB,$@)
	$(Q)$(METHOD_EPUB_XSL1_SCRIPT) "$@" "$(shell dirname "$<")"
