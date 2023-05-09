## METHOD: latex-latexml-dedoc
###############################################################################
METHOD_LATEX_LATEXML_DEDOC_DIR=$(DEDOC_BASE)/methods/latex-latexml-dedoc/

DOC_LATEX=$(BUILD_DIR)/int/$(DOCNAME).latex/$(DOCNAME).tex

DTEXML=$(METHOD_LATEXML_DEDOC_DIR)/dtexml
DTEXML_CHAR_DB_PATH=$(BUILD_DIR)/int/dtexml-unicode.db
UNICODE_XML=$(BUILD_DIR)/int/unicode.xml
UNICODE_XML_URL=https://github.com/w3c/xml-entities/raw/gh-pages/unicode.xml

.PHONY: method_latex-latexml-dedoc_all
.PRECIOUS: $(UNICODE_XML)

method_latex-latexml-dedoc_all: $(DOC_LATEX)

$(DOC_LATEX): $(DOC_LATEXML) $(DTEXML_CHAR_DB_PATH)
	$(call INFO,DTEXML,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)$(DTEXML) convert -m $(DTEXML_CHAR_DB_PATH) "$<" "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(DTEXML_CHAR_DB_PATH): $(UNICODE_XML)
	$(call INFO,DTEXML-DB,$@)
	$(Q)$(DTEXML) build-char-mapping-db "$<" "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(UNICODE_XML):
	$(call INFO,WGET,$@)
	$(Q)$(WGET) -O "$@.tmp" "$(UNICODE_XML_URL)"
	$(Q)mv "$@.tmp" "$@"
