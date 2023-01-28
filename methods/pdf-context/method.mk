## METHOD: pdf-context
###############################################################################
METHOD_PDF_CONTEXT_DIR=$(DEDOC_BASE)/methods/pdf-context/
METHOD_PDF_CONTEXT_DRIVER_NAME=dedoc-pdf.tex
METHOD_PDF_CONTEXT_DRIVER_PATH=$(METHOD_PDF_CONTEXT_DIR)/$(METHOD_PDF_CONTEXT_DRIVER_NAME)
METHOD_PDF_CONTEXT_PRE_FN?=$(DOCNAME)-pre.tex

DOC_TEX=$(BUILD_DIR)/int/$(DOCNAME).tex
DOC_PDF=$(BUILD_DIR)/out/$(DOCNAME).pdf
DOC_PDF_INT=$(BUILD_DIR)/int/$(DOCNAME).pdf

.PHONY: method_pdf-context_all

method_pdf-context_all: $(DOC_PDF)

$(DOC_PDF): $(DOC_PDF_INT)
	$(Q)ln -f "$<" "$@"

$(DOC_PDF_INT): $(DOC_TEX) $(METHOD_PDF_CONTEXT_DRIVER_PATH) $(DOC_XML)
	$(call INFO,CONTEXT,$@)
	$(Q)mkdir -p "$$(dirname "$(DOC_PDF)")"
	$(Q)(set -e; cd "$$(dirname "$(DOC_TEX)")"; $(CONTEXT) $(CONTEXT_ARGS) \
		--path=$(METHOD_PDF_CONTEXT_DIR)/,$(METHOD_PDF_CONTEXT_DIR)/overrides/ \
		"$(patsubst $(BUILD_DIR)/int/%,%,$<)"; )

$(DOC_TEX): $(DOC_XML)
	$(call INFO,TEX,$@)
	$(Q)mkdir -p "$$(dirname "$@")"
	$(Q)echo "\xdef\ArgInput{../$(patsubst $(BUILD_DIR)/%,%,$(DOC_XML))}" > "$@.tmp"
	$(Q)echo "\xdef\AssetPath{...}" >> "$@.tmp"
	$(Q)if [ -e "$(METHOD_PDF_CONTEXT_PRE_FN)" ]; then \
	  echo  "\input{$$(realpath "$(METHOD_PDF_CONTEXT_PRE_FN)")}" >> "$@.tmp"; \
	fi
	$(Q)echo "\input{$(METHOD_PDF_CONTEXT_DRIVER_PATH)}" >> "$@.tmp"
	$(Q)mv "$@.tmp" "$@"
