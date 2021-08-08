gh-pages/spacenews.xml:
	python spacenews.py

all: gh-pages/spacenews.xml
	$(MAKE) -C gh-pages all

publish:
	$(MAKE) -C gh-pages publish

clean:
	rm gh-pages/spacenews.xml
	$(MAKE) -C gh-pages clean
