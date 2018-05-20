## Put this Makefile in your project directory---i.e., the directory
## containing the paper you are writing. Assuming you are using the
## rest of the toolchain here, you can use it to create .html, .tex,
## and .pdf output files (complete with bibliography, if present) from
## your markdown or Rmarkdown fies.
## -	Change the paths at the top of the file as needed.
## -	Using `make` without arguments will generate html, tex, and pdf
## 	output files from all of the files with the designated markdown
##	extension. The default is `.md` but you can change this.
## -	You can specify an output format with `make tex`, `make pdf`,
## - 	`make html`, or `make docx`.
## -	Doing `make clean` will remove all the .tex, .html, .pdf, and .docx files
## 	in your working directory. Make sure you do not have files in these
##	formats that you want to keep!

## Markdown extension (e.g. md, markdown, mdown).
MEXT = md

## All markdown files in the working directory
SRC = $(wildcard *.$(MEXT))

## Store compiled files here
DIST = dist

## Location of Pandoc support files.
PREFIX = $(HOME)/.pandoc

## Location of your working bibliography file
BIB = $(HOME)/.pandoc/bibliography.bib

## CSL stylesheet (located in the csl folder of the PREFIX directory).
CSL = mla

## Pandoc options to use
OPTIONS = markdown+smart+tex_math_single_backslash
EXTRAS = -N --highlight-style tango

MD=$(SRC:.Rmd=.md)

PDFS=$(SRC:.md=.pdf)
HTML=$(SRC:.md=.html)
TEX=$(SRC:.md=.tex)
DOCX=$(SRC:.md=.docx)


all:	clean $(MD) $(PDFS) $(HTML) $(TEX) $(DOCX)

md:	$(MD)
pdf:	$(PDFS)
html:	$(HTML)
tex:	$(TEX)
docx:	$(DOCX)

%.html:	%.md
	pandoc \
			-r $(OPTIONS) \
			-w html \
			--template tufte \
			--filter pandoc-citeproc \
			--csl $(PREFIX)/csl/$(CSL).csl \
			--css $(PREFIX)/css/tufte.css \
			--bibliography $(BIB) \
			$(EXTRAS) \
			-o $(DIST)/html/$@ $<

%.tex:	%.md
	pandoc \
			-r $(OPTIONS) \
			-w latex \
			--pdf-engine pdflatex \
			--template notebook \
			--filter pandoc-citeproc \
			--csl $(PREFIX)/csl/$(CSL).csl \
			--bibliography $(BIB) \
			$(EXTRAS) \
			-o $(DIST)/tex/$@ $<

%.pdf:	%.md
	pandoc \
			-r $(OPTIONS) \
			--pdf-engine pdflatex \
			--template notebook \
			--filter pandoc-citeproc \
			--csl $(PREFIX)/csl/$(CSL).csl \
			--bibliography $(BIB) \
			$(EXTRAS) \
			-o $(DIST)/pdf/$@ $<

%.docx: %.md
	pandoc \
			-r $(OPTIONS) \
			-w docx \
			--filter pandoc-citeproc \
			--csl $(PREFIX)/csl/$(CSL).csl \
			--bibliography $(BIB) \
			$(EXTRAS) \
			-o $(DIST)/docx/$@ $<

clean:
	find $(DIST) -type f -exec rm -f {} \;

archive:
	tar -cjvf dist-$(shell date date +%Y-%M-%d).tar.bz2 $(DIST)/