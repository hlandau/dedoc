## Usage:
##   Option 1: source `mk/dedoc-shell.sh` in bash, run `dedoc`
##						 inside directory containing a dd-*.scm file (or
##						 run `bin/dedoc` directly).
##   Option 2: symlink this file to Makefile in a directory containing a
##             dd-*.scm file and run make.

## OVERRIDABLES
###############################################################################
DOCNAME?=
BUILD_DIR?=build
METHODS?=dedoc-guile pdf-context xhtml-single-xsl1 epub-xsl1 mdoc-xsl1 txt-roff-mdoc-xsl1 txt-mandoc-mdoc-xsl1 fo-xsl1 pdf-fop-fo-xsl1


## INTERNAL CONFIGURATION
###############################################################################
DEDOC_MAKEFILE_PATH:=$(word $(words $(MAKEFILE_LIST)), $(MAKEFILE_LIST))
DEDOC_BASE?=$(shell cd "$(shell dirname "$(DEDOC_MAKEFILE_PATH)")/.."; pwd)
DEDOC_COMPILED_SCHEMA_DIR?=$(DEDOC_BASE)/schema/build
DEDOC_RNG?=$(DEDOC_COMPILED_SCHEMA_DIR)/dedoc.rng
DEDOC_RNC?=$(DEDOC_COMPILED_SCHEMA_DIR)/dedoc.rnc
.DEFAULT_GOAL=all

include $(DEDOC_BASE)/mk/support.mk
-include Makefile.config
METHOD_ALLS=$(patsubst %,method_%_all,$(METHODS))

ifeq ($(DOCNAME),)
DOCNAME:=$(patsubst %.scm,%,$(shell ls dd-*.scm))
endif
ifneq ($(words $(DOCNAME)),1)
$(error If more or less than one file named dd-*.scm is in a directory, \
        DOCNAME must be specified explicitly; have "$(DOCNAME)")
endif

include $(patsubst %,$(DEDOC_BASE)/methods/%/method.mk,$(METHODS))

.PHONY: all clean
all: $(METHOD_ALLS)


## GENERAL
###############################################################################
clean:
	rm -rf "$(BUILD_DIR)"
