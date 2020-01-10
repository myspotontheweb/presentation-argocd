OUTDIR = docs
BINDIR = bin

SRC  = $(wildcard *.adoc)
HTML = $(OUTDIR)/$(SRC:.adoc=.html)
PDF  = $(OUTDIR)/$(SRC:.adoc=.pdf)

html: $(HTML)

pdf: $(PDF)

$(OUTDIR)/%.html: %.adoc $(BINDIR)/asciidoctor-reveal.js $(OUTDIR)/reveal.js
	asciidoctor -T $(BINDIR)/asciidoctor-reveal.js/templates -r asciidoctor-diagram -b revealjs $< -o $@

$(OUTDIR)/%.pdf: $(OUTDIR)/%.html
	docker run --rm -v $(PWD):/data astefanutti/decktape /data/$< /data/$@

$(BINDIR)/asciidoctor-reveal.js: 
	mkdir $(BINDIR)
	curl -L https://github.com/asciidoctor/asciidoctor-reveal.js/archive/v1.1.3.tar.gz | tar zx
	mv -f asciidoctor-reveal.js-1.1.3 $@

$(OUTDIR)/reveal.js: 
	mkdir $(OUTDIR)
	curl -L https://github.com/hakimel/reveal.js/archive/3.6.0.tar.gz | tar zx
	mv -f reveal.js-3.6.0 $@

clean:
	rm -f $(OUTDIR)/*.html

clean-all: 
	rm -rf $(OUTDIR)
	rm -rf $(BINDIR)
