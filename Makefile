spacenews.html: spacenews.xsl spacenews.xml
	xsltproc --stringparam format image $^ > $@

spacenews_text.html: spacenews.xsl spacenews.xml
	xsltproc --stringparam format text  $^ > $@

rss.xml: rss.xsl spacenews.xml
	xsltproc $^ > $@

all: spacenews.html spacenews_text.html rss.xml

clean:
	rm spacenews.html
	rm spacenews_text.html
	rm rss.xml

publish:
	git add -A
	git commit -m "Update gh-pages"
	git push
