spacenews.html: spacenews.xsl spacenews.xml
	xsltproc $^ > $@

rss.xml: rss.xsl spacenews.xml
	xsltproc $^ > $@

all: spacenews.html rss.xml

clean:
	rm spacenews.html
	rm rss.xml

publish:
	git add -A
	git commit -m "Update gh-pages"
	git push
