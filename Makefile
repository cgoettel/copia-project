copia-project.pdf: *.tex episodes/* generate-tex.pl Makefile
	rm -f *.aux */*.aux
	./generate-tex.pl
	xelatex -halt-on-error copia-project.tex
	xelatex copia-project.tex
	xelatex -halt-on-error cover-letter.tex
	xelatex cover-letter.tex
	pdfunite cover-letter.pdf copia-project.pdf Colby\ Goettel\ Copia\ Project.pdf
