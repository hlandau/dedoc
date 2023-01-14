## METHOD: mdoc-xsl1
###############################################################################
METHOD_MDOC_XSL1_DIR=$(DEDOC_BASE)/methods/mdoc-xsl1/
METHOD_MDOC_XSL1_RULES=$(BUILD_DIR)/int/$(DOCNAME).mdoc.mk
METHOD_MDOC_XSL1_OUT_DIR=$(BUILD_DIR)/out/$(DOCNAME).mdoc
METHOD_MDOC_XSL1_INT_DIR=$(BUILD_DIR)/int/$(DOCNAME).mdoc
METHOD_MDOC_XSL1_DEDOC2ROFFML=$(METHOD_MDOC_XSL1_DIR)/dedoc2roffml.xsl
METHOD_MDOC_XSL1_XML2ROFF=$(METHOD_MDOC_XSL1_DIR)/xml2roff.xsl

METHOD_MDOC_XSL1_DEPS_EXPR=$$(patsubst $(METHOD_MDOC_XSL1_INT_DIR)/%.xml,$(METHOD_MDOC_XSL1_OUT_DIR)/%,$$(wildcard $(METHOD_MDOC_XSL1_INT_DIR)/*.xml))
METHOD_MDOC_XSL1_NAMES=$(patsubst $(METHOD_MDOC_XSL1_INT_DIR)/%.xml,%,$(wildcard $(METHOD_MDOC_XSL1_INT_DIR)/*.xml))

# No feature tag for .WAIT but notintermediate was also introduced with 4.4
# so test for that instead.
ifeq ($(filter notintermediate,$(value .FEATURES)),)
$(error Unsupported version of make; mdoc build support requires \
	GNU make 4.4 or later as .WAIT support is required)
endif

.PHONY: method_mdoc-xsl1_all method_mdoc-xsl1_rules method_mdoc-xsl1_actual

method_mdoc-xsl1_all: $(METHOD_MDOC_XSL1_RULES) .WAIT method_mdoc-xsl1_actual
method_mdoc-xsl1_rules: $(METHOD_MDOC_XSL1_RULES)

.SECONDEXPANSION:
.PRECIOUS: $(METHOD_MDOC_XSL1_INT_DIR)/%.roffml
method_mdoc-xsl1_actual: $(METHOD_MDOC_XSL1_DEPS_EXPR)
	$(Q)true

$(METHOD_MDOC_XSL1_OUT_DIR)/%: $(METHOD_MDOC_XSL1_INT_DIR)/%.roffml
	$(call INFO,XSLTPROC,$@)
	$(Q)mkdir -p "$$(dirname "$@")"
	$(Q)$(XSLTPROC) "$(METHOD_MDOC_XSL1_XML2ROFF)" "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_MDOC_XSL1_INT_DIR)/%.roffml: $(METHOD_MDOC_XSL1_INT_DIR)/%.xml
	$(call INFO,XSLTPROC,$@)
	$(Q)$(XSLTPROC) "$(METHOD_MDOC_XSL1_DEDOC2ROFFML)" "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

$(METHOD_MDOC_XSL1_INT_DIR)/%.xml: $(METHOD_MDOC_XSL1_RULES)
	@# This line is necessary to make make actually believe this rule
	@# can produce the target.
	$(Q)true

$(METHOD_MDOC_XSL1_RULES): $(DOC_XML)
	$(call INFO,MDOC,$@)
	$(Q)mkdir -p "$(shell dirname "$@")" "$(METHOD_MDOC_XSL1_INT_DIR)"
	$(Q)rm -f "$@"
	$(Q)$(XMLCMD) sel -N d=https://www.devever.net/ns/dedoc -t -m '//d:sec[@man-section]' \
	  -o '#@---- ' -v d:hdr/d:title -o ' ' -v @man-section -n -c . -n "$<" | \
	  $(AWK) '/#@---- .*/{x="$(METHOD_MDOC_XSL1_INT_DIR)/"$$2"."$$3".newxml";next}{print>x;}'
	$(Q)set -e; shopt -s nullglob; \
	  for x in $(METHOD_MDOC_XSL1_INT_DIR)/*.xml; do \
	    if ! [ -e "$$(basename "$$x" .xml).newxml" ]; then \
	      rm -f "$$x"; \
	    fi; \
	  done; \
	  for x in $(METHOD_MDOC_XSL1_INT_DIR)/*.newxml; do \
	    bn="$$(basename "$$x" .newxml)"; \
	    y="$(METHOD_MDOC_XSL1_INT_DIR)/$$bn.xml"; \
	    if [ -e "$$y" ]; then \
	      if ! cmp -s "$$x" "$$y"; then \
	        echo "mdoc: updating $$y"; \
	        mv "$$x" "$$y"; \
	      else \
	        rm -f "$$x"; \
	      fi; \
	    else \
	      mv "$$x" "$$y"; \
	    fi; \
	  done; \
	  touch "$@"

# groff -mandoc -Tutf8 -dpaper=a4 -rcR=0 < xxx > xxx.txt
