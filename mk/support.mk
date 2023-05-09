MAKEFLAGS+=-r
ifeq ($(V),)
Q=@
else
Q=
endif
ZINFO=echo -e "\t$(1)\t$(2)"
INFO=@echo -e "\t$(1)\t$(2)"

RNV?=rnv
XSLTPROC?=xsltproc
XMLLINT?=xmllint
GUILE?=guile
GUILE_ARGS?=--fresh-auto-compile --no-auto-compile
GUILE_LIBS?=-L "$(DEDOC_BASE)/schema/" -L .
CONTEXT?=context
CONTEXT_ARGS?=--batchmode --noconsole
XMLCMD?=xml
AWK?=awk
GROFF?=groff
PS2PDF?=ps2pdf
MANDOC?=mandoc
COL?=col
GIT?=git
FOP?=fop
WGET?=wget
LUALATEX?=lualatex
LUALATEX_ARGS?=
