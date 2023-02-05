## METHOD: dedoc-guile
###############################################################################
METHOD_DEDOC_GUILE_DIR=$(DEDOC_BASE)/methods/dedoc-guile/

DOC_XML=$(BUILD_DIR)/out/$(DOCNAME).xml
DOC_XML_PRETTY=$(BUILD_DIR)/out/$(DOCNAME).pretty.xml
DOC_SCM=$(DOCNAME).scm

.PHONY: method_dedoc-guile_all

method_dedoc-guile_all: $(DOC_XML_PRETTY)

$(DOC_XML): $(DOC_SCM)
	$(call INFO,GENDOC,$@)
	$(Q)mkdir -p "$(shell dirname "$@")"
	$(Q)set -e; \
	IS_GIT="$$("$(GIT)" rev-parse --is-inside-work-tree 2>/dev/null || true)"; \
	if [ "$$IS_GIT" == "true" ]; then \
	  export GITINFO_SHORT="$$("$(GIT)" describe --dirty=+ --always)"; \
	  export GITINFO_LONG="$$("$(GIT)" describe --dirty=+ --always --long --abbrev=99)"; \
	  export GITINFO_REV="$$("$(GIT)" rev-parse HEAD)"; \
		if ! [ "$$("$(GIT)" diff --quiet)" ]; then \
			export GITINFO_REV="$${GITINFO_REV}+"; \
		fi; \
		export GITINFO_TIME="$$("$(GIT)" log -1 --format=format:%cI)"; \
	fi; \
	if head -n 1 "$<" | grep -q '^#!'; then \
	  "$<" > "$@.tmp"; \
	else \
	  $(GUILE) $(GUILE_ARGS) $(GUILE_LIBS) -c "(use-modules ($(DOCNAME)) ((dedoc) #:select (postprocess)) (sxml2)) (sxml->xml (postprocess (top)))" > "$@.tmp"; \
	fi
	$(Q)if [ -e "$(DEDOC_RNC)" ]; then \
	  $(call ZINFO,RNC,$@); \
	  $(RNV) -q "$(DEDOC_RNC)" "$@.tmp"; \
	else \
	  echo >&2 "WARNING: dedoc schema not available; skipping output validation."; \
	fi
	$(Q)mv "$@.tmp" "$@"

$(DOC_XML_PRETTY): $(DOC_XML)
	$(call INFO,PRETTY,$@)
	$(Q)$(XMLLINT) --pretty 2 --nsclean "$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"
