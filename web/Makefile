.PHONY: all enter clean

SRC_DIR=.
BUILD_DIR=build
OUT_DIR=$(BUILD_DIR)/out
SASS?=sass

all: $(OUT_DIR)/index.xhtml $(OUT_DIR)/dedoc-website.css $(OUT_DIR)/slash.svg

enter:
	nix-shell -p guile sass

clean:
	rm -rf build

$(OUT_DIR)/index.xhtml: $(SRC_DIR)/website.scm
	mkdir -p "$(OUT_DIR)"
	./"$<"

$(OUT_DIR)/dedoc-website.css: $(SRC_DIR)/assets/dedoc-website.scss
	$(SASS) --cache-location "$(BUILD_DIR)/.sass-cache" "$<" "$@"

$(OUT_DIR)/slash.svg: $(SRC_DIR)/assets/slash.svg
	cp -a "$<" "$@"
