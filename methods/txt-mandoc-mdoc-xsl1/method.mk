## METHOD: txt-mandoc-mdoc-xsl1
###############################################################################
METHOD_TXT_MANDOC_MDOC_XSL1_DIR=$(DEDOC_BASE)/methods/txt-mandoc-mdoc-xsl1/
METHOD_TXT_MANDOC_MDOC_XSL1_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-mandoc-txt
METHOD_TXTU_MANDOC_MDOC_XSL1_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-mandoc-txtu
METHOD_PS_MANDOC_MDOC_XSL1_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-mandoc-ps
METHOD_PDF_MANDOC_MDOC_XSL1_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-mandoc-pdf
METHOD_XHTML_MANDOC_MDOC_XSL1_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-mandoc-xhtml

METHOD_TXT_MANDOC_MDOC_XSL1_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_TXT_MANDOC_MDOC_XSL1_OUT_DIR)/$$(x).txt)
METHOD_TXTU_MANDOC_MDOC_XSL1_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_TXTU_MANDOC_MDOC_XSL1_OUT_DIR)/$$(x).txt)
METHOD_PS_MANDOC_MDOC_XSL1_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_PS_MANDOC_MDOC_XSL1_OUT_DIR)/$$(x).ps)
METHOD_PDF_MANDOC_MDOC_XSL1_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_PDF_MANDOC_MDOC_XSL1_OUT_DIR)/$$(x).pdf)
METHOD_XHTML_MANDOC_MDOC_XSL1_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_XHTML_MANDOC_MDOC_XSL1_OUT_DIR)/$$(x).xhtml)

.PHONY: method_txt-mandoc-mdoc-xsl1_all

method_txt-mandoc-mdoc-xsl1_all: $(METHOD_TXT_MANDOC_MDOC_XSL1_TARGETS_EXPR) $(METHOD_TXTU_MANDOC_MDOC_XSL1_TARGETS_EXPR) $(METHOD_PS_MANDOC_MDOC_XSL1_TARGETS_EXPR) $(METHOD_PDF_MANDOC_MDOC_XSL1_TARGETS_EXPR) $(METHOD_XHTML_MANDOC_MDOC_XSL1_TARGETS_EXPR)
	$(Q)true

$(METHOD_TXT_MANDOC_MDOC_XSL1_OUT_DIR)/%.txt: $(METHOD_TXTU_MANDOC_MDOC_XSL1_OUT_DIR)/%.txt
	$(call INFO,COL,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(COL) -b < "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_TXTU_MANDOC_MDOC_XSL1_OUT_DIR)/%.txt: $(METHOD_MDOC_XSL1_OUT_DIR)/%
	$(call INFO,MANDOC,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(MANDOC) -mdoc -Kutf-8 -Tutf8 < "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_PS_MANDOC_MDOC_XSL1_OUT_DIR)/%.ps: $(METHOD_MDOC_XSL1_OUT_DIR)/%
	$(call INFO,MANDOC,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(MANDOC) -mdoc -Kutf-8 -Tps < "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_PDF_MANDOC_MDOC_XSL1_OUT_DIR)/%.pdf: $(METHOD_MDOC_XSL1_OUT_DIR)/%
	$(call INFO,MANDOC,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(MANDOC) -mdoc -Kutf-8 -Tpdf < "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_XHTML_MANDOC_MDOC_XSL1_OUT_DIR)/%.xhtml: $(METHOD_MDOC_XSL1_OUT_DIR)/%
	$(call INFO,MANDOC,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(MANDOC) -mdoc -Kutf-8 -Thtml < "$<" | $(DEDOC_BASE)/mk/html2xhtml > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"
