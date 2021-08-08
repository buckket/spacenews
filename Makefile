gh-pages/spacenews.xml: FORCE
	python spacenews.py

.PHONY: FORCE all publish clean

FORCE:

all: gh-pages/spacenews.xml
	$(MAKE) -C gh-pages all

publish:
	$(MAKE) -C gh-pages publish

clean:
	rm gh-pages/spacenews.xml
	$(MAKE) -C gh-pages clean
