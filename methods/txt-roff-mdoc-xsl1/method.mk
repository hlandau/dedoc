## METHOD: txt-roff-mdoc-xsl1
###############################################################################
METHOD_TXT_ROFF_MDOC_XSL1_DIR=$(DEDOC_BASE)/methods/txt-roff-mdoc-xsl1/
METHOD_TXT_ROFF_MDOC_XSL1_NONPAGINATED_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-roff-txt
METHOD_TXT_ROFF_MDOC_XSL1_PAGINATED_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-roff-ptxt
METHOD_TXTU_ROFF_MDOC_XSL1_NONPAGINATED_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-roff-txtu
METHOD_TXTU_ROFF_MDOC_XSL1_PAGINATED_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-roff-ptxtu
METHOD_PS_ROFF_MDOC_XSL1_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-roff-ps
METHOD_PDF_PS_ROFF_MDOC_XSL1_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-roff-pdf
METHOD_XHTML_ROFF_MDOC_XSL1_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc-roff-xhtml

METHOD_TXT_ROFF_MDOC_XSL1_NONPAGINATED_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_TXT_ROFF_MDOC_XSL1_NONPAGINATED_OUT_DIR)/$$(x).txt)
METHOD_TXT_ROFF_MDOC_XSL1_PAGINATED_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_TXT_ROFF_MDOC_XSL1_PAGINATED_OUT_DIR)/$$(x).txt)
METHOD_TXTU_ROFF_MDOC_XSL1_NONPAGINATED_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_TXTU_ROFF_MDOC_XSL1_NONPAGINATED_OUT_DIR)/$$(x).txt)
METHOD_TXTU_ROFF_MDOC_XSL1_PAGINATED_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_TXTU_ROFF_MDOC_XSL1_PAGINATED_OUT_DIR)/$$(x).txt)
METHOD_PS_ROFF_MDOC_XSL1_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_PS_ROFF_MDOC_XSL1_OUT_DIR)/$$(x).ps)
METHOD_PDF_PS_ROFF_MDOC_XSL1_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_PDF_PS_ROFF_MDOC_XSL1_OUT_DIR)/$$(x).pdf)
METHOD_XHTML_ROFF_MDOC_XSL1_TARGETS_EXPR=$$(foreach x,$$(METHOD_MDOC_XSL1_NAMES),$(METHOD_XHTML_ROFF_MDOC_XSL1_OUT_DIR)/$$(x).xhtml)

.PHONY: method_txt-roff-mdoc-xsl1_all

method_txt-roff-mdoc-xsl1_all: $(METHOD_TXT_ROFF_MDOC_XSL1_NONPAGINATED_TARGETS_EXPR) $(METHOD_TXT_ROFF_MDOC_XSL1_PAGINATED_TARGETS_EXPR) $(METHOD_TXTU_ROFF_MDOC_XSL1_NONPAGINATED_TARGETS_EXPR) $(METHOD_TXTU_ROFF_MDOC_XSL1_PAGINATED_TARGETS_EXPR) $(METHOD_PS_ROFF_MDOC_XSL1_TARGETS_EXPR) $(METHOD_PDF_PS_ROFF_MDOC_XSL1_TARGETS_EXPR) $(METHOD_XHTML_ROFF_MDOC_XSL1_TARGETS_EXPR)
	$(Q)true

$(METHOD_TXT_ROFF_MDOC_XSL1_NONPAGINATED_OUT_DIR)/%.txt: $(METHOD_TXTU_ROFF_MDOC_XSL1_NONPAGINATED_OUT_DIR)/%.txt
	$(call INFO,COL,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(COL) -b < "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_TXT_ROFF_MDOC_XSL1_PAGINATED_OUT_DIR)/%.txt: $(METHOD_TXTU_ROFF_MDOC_XSL1_PAGINATED_OUT_DIR)/%.txt
	$(call INFO,COL,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(COL) -b < "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_TXTU_ROFF_MDOC_XSL1_NONPAGINATED_OUT_DIR)/%.txt: $(METHOD_MDOC_XSL1_OUT_DIR)/%
	$(call INFO,GROFF,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(GROFF) -mdoc -Tutf8 -dpaper=a4 < "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_TXTU_ROFF_MDOC_XSL1_PAGINATED_OUT_DIR)/%.txt: $(METHOD_MDOC_XSL1_OUT_DIR)/%
	$(call INFO,GROFF,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(GROFF) -mdoc -Tutf8 -dpaper=a4 -rcR=0 < "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_PS_ROFF_MDOC_XSL1_OUT_DIR)/%.ps: $(METHOD_MDOC_XSL1_OUT_DIR)/%
	$(call INFO,GROFF,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(GROFF) -mdoc -Tps -dpaper=a4 < "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_PDF_PS_ROFF_MDOC_XSL1_OUT_DIR)/%.pdf: $(METHOD_PS_ROFF_MDOC_XSL1_OUT_DIR)/%.ps
	$(call INFO,PS2PDF,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(PS2PDF) "$<" "$@"

$(METHOD_XHTML_ROFF_MDOC_XSL1_OUT_DIR)/%.xhtml: $(METHOD_MDOC_XSL1_OUT_DIR)/%
	$(call INFO,GROFF,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(GROFF) -mdoc -Txhtml < "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"
