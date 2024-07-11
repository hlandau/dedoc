## METHOD: pdf-sile
###############################################################################
#!priority=10
METHOD_PDF_SILE_DIR=$(DEDOC_BASE)/methods/pdf-sile/
DOC_PDF=$(BUILD_DIR)/out/$(DOCNAME).pdf
SILE ?= sile

.PHONY: method_pdf-sile_all

method_pdf-sile_all: $(DOC_PDF)

$(DOC_PDF): $(DOC_XML) $(METHOD_PDF_SILE_DIR)/ddbook.lua
	$(call INFO,SILE,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)SILE_PATH=$(METHOD_PDF_SILE_DIR) $(SILE) -c ddbook -o "$@.tmp" "$<"
	$(Q)mv "$@.tmp" "$@"
