# Makefile for local testing of the Overleaf-style Beamer template
# Requires: latexmk + a TeX distribution (TeX Live / MacTeX / MikTeX)

THEME_DIR := theme
# Put theme/ first in TeX's search path (// = recursive). Trailing ':' keeps default paths.
TEXINPUTS_PREFIX := $(THEME_DIR)//:

MAIN      := main.tex
OUTDIR    := .
ENGINE    ?= lualatex
# pdflatex | lualatex | xelatex

LATEXMK   := latexmk
LATEXMK_COMMON := -shell-escape -interaction=nonstopmode -halt-on-error -file-line-error

ifeq ($(ENGINE),pdflatex)
  LATEXMK_ENGINE := -pdf
else ifeq ($(ENGINE),lualatex)
  LATEXMK_ENGINE := -lualatex
else ifeq ($(ENGINE),xelatex)
  LATEXMK_ENGINE := -xelatex
else
  $(error Unknown ENGINE '$(ENGINE)'; use pdflatex|lualatex|xelatex)
endif

PDF := $(OUTDIR)/$(basename $(MAIN)).pdf

.PHONY: all pdf watch clean distclean open

all: pdf

$(OUTDIR):
	mkdir -p $(OUTDIR)

pdf: $(OUTDIR)
	TEXINPUTS="$(TEXINPUTS_PREFIX)$$TEXINPUTS" \
	$(LATEXMK) $(LATEXMK_ENGINE) $(LATEXMK_COMMON) -outdir=$(OUTDIR) $(MAIN)

watch: $(OUTDIR)
	TEXINPUTS="$(TEXINPUTS_PREFIX)$$TEXINPUTS" \
	$(LATEXMK) $(LATEXMK_ENGINE) $(LATEXMK_COMMON) -pvc -outdir=$(OUTDIR) $(MAIN)

clean:
	TEXINPUTS="$(TEXINPUTS_PREFIX)$$TEXINPUTS" \
	$(LATEXMK) -C -outdir=$(OUTDIR) $(MAIN)

distclean: clean
	-rm -rf $(OUTDIR)

open: pdf
	@{ command -v xdg-open >/dev/null 2>&1 && xdg-open "$(PDF)" || \
	   command -v open >/dev/null 2>&1 && open "$(PDF)" || \
	   echo "Built: $(PDF)"; }
