## METHOD: pdf-fop-fo-xsl1
###############################################################################
METHOD_PDF_FOP_FO_XSL1_DIR=$(DEDOC_BASE)/methods/pdf-fop-fo-xsl1/
METHOD_PDF_FOP_FO_XSL1_CONFIG_NAME=fopconfig.xml
METHOD_PDF_FOP_FO_XSL1_CONFIG_PATH=$(METHOD_PDF_FOP_FO_XSL1_DIR)/$(METHOD_PDF_FOP_FO_XSL1_CONFIG_NAME)

DOC_PDF_FO=$(BUILD_DIR)/out/$(DOCNAME)-fo.pdf

.PHONY: method_pdf-fop-fo-xsl1_all

method_pdf-fop-fo-xsl1_all: $(DOC_PDF_FO)

$(DOC_PDF_FO): $(DOC_FO) $(METHOD_PDF_FOP_FO_XSL1_CONFIG_PATH)
	$(call INFO,FOP,$@)
	$(Q)mkdir -p "$$(dirname "$(DOC_PDF)")"
	$(Q)$(FOP) -c "$(METHOD_PDF_FOP_FO_XSL1_CONFIG_PATH)" "$<" "$@"
