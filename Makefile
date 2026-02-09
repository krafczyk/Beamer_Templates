# Makefile for local testing of the Overleaf-style Beamer template
# Requires: latexmk + a TeX distribution (TeX Live / MacTeX / MikTeX)

MAIN      := main.tex
OUTDIR    := build
ENGINE    ?= pdflatex
# pdflatex | lualatex | xelatex

LATEXMK   := latexmk
LATEXMK_COMMON := -interaction=nonstopmode -halt-on-error -file-line-error

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
	$(LATEXMK) $(LATEXMK_ENGINE) $(LATEXMK_COMMON) -outdir=$(OUTDIR) $(MAIN)

watch: $(OUTDIR)
	$(LATEXMK) $(LATEXMK_ENGINE) $(LATEXMK_COMMON) -pvc -outdir=$(OUTDIR) $(MAIN)

clean:
	-$(LATEXMK) -C -outdir=$(OUTDIR) $(MAIN)

distclean: clean
	-rm -rf $(OUTDIR)

open: pdf
	@{ command -v xdg-open >/dev/null 2>&1 && xdg-open "$(PDF)" || \
	   command -v open >/dev/null 2>&1 && open "$(PDF)" || \
	   echo "Built: $(PDF)"; }
