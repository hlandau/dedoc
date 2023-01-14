.PHONY: all enter clean check lint specimens

SRC_DIR=..
MK_DIR=$(SRC_DIR)/mk
BUILD_DIR=build

include $(MK_DIR)/Makefile.support

all: $(BUILD_DIR)/index.xhtml $(BUILD_DIR)/dedoc.css $(BUILD_DIR)/dedoc.rnc $(BUILD_DIR)/dedoc.rng $(BUILD_DIR)/rng.xsl

enter:
	nix-shell -p libxml2 libxslt rnv guile xmlstarlet zip

clean:
	rm -rf build

check: $(BUILD_DIR)/dedoc.rnc $(BUILD_DIR)/dedoc.xhtml
	$(RNV) $^

# Allow web browser to style XHTML.
$(BUILD_DIR)/dedoc.css:
	$(call INFO,LINK,$@)
	$(Q)ln "dedoc.css" "$@"

# Allow web browser to style RNG XML.
$(BUILD_DIR)/rng.xsl:
	$(call INFO,LINK,$@)
	$(Q)ln "xsl-support/rng.xsl" "$@"

# RNG compact file.
$(BUILD_DIR)/%.rnc: xsl-support/extract-rnc.xsl $(BUILD_DIR)/%.xhtml
	$(call INFO,RNC,$@)
	$(Q)$(XSLTPROC) $^ > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

# RNG XML file.
$(BUILD_DIR)/%.rng: xsl-support/extract-rng.xsl $(BUILD_DIR)/%.xhtml
	$(call INFO,RNG,$@)
	$(Q)$(XSLTPROC) $^ > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

# Can be used to temporarily make the output XHTML readable for debugging
# purposes.
lint: $(BUILD_DIR)/dedoc.xhtml
	$(call INFO,LINT)
	$(Q)$(XMLLINT) --pretty 2 --nsclean "$<" > "$(BUILD_DIR)/dedoc.xhtml.tmp"
	$(Q)mv "$(BUILD_DIR)/dedoc.xhtml.tmp" "$<"
	$(Q)$(XMLLINT) --pretty 1 --nsclean "$(BUILD_DIR)/dedoc.rng" > "$(BUILD_DIR)/dedoc.rng.tmp"
	$(Q)mv "$(BUILD_DIR)/dedoc.rng.tmp" "$(BUILD_DIR)/dedoc.rng"

# Symlink for web servers.
$(BUILD_DIR)/index.xhtml: $(BUILD_DIR)/dedoc.xhtml
	$(call INFO,LINK,$@)
	$(Q)ln -sf dedoc.xhtml "$@"

# The postprocessed XHTML file with inline hybrid RNG-RNC and TOC.
$(BUILD_DIR)/%.xhtml: xsl-support/post.xsl $(BUILD_DIR)/%-pre.xhtml
	$(call INFO,DEDOC-XHTML,$@)
	$(Q)$(XSLTPROC) $^ > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"

# The initial XHTML file which is the direct output of the dedoc script.
$(BUILD_DIR)/%-pre.xhtml: %.scm
	$(call INFO,DEDOC-GEN,$@)
	$(Q)mkdir -p build/figs
	$(Q)./"$<" > "$@.tmp"
	$(Q)mv "$@.tmp" "$@"
