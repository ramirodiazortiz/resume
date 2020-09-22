RESUME_TMPL = resume.tmpl
RESUME_MD = resume.md
RESUME_HTML = index.html
RESUME_PDF = resume.pdf
RESUME_DOCX = resume.docx

STYLE_STYL = style.styl
STYLE_CSS = style.css
FONTS = fonts.css

SRC_DIR = src
BUILD_DIR = build

PANDOC = pandoc
STYLUS = ./node_modules/stylus/bin/stylus
SERVER = ./node_modules/browser-sync/bin/browser-sync.js start --reload-delay 500 --files $(BUILD_DIR) --server $(BUILD_DIR) --port 8000

TITLE = "Ramiro Diaz Ortiz"
GITHUB_USER = ramirodiazortiz

default: compile

deps:
	npm install

clean:
	rm -rf $(BUILD_DIR)/*
	rm -rf $(BUILD_DIR)/.git
	
compile:
	mkdir -p $(BUILD_DIR)
	cp $(SRC_DIR)/$(FONTS) $(BUILD_DIR)/
	$(STYLUS) $(SRC_DIR)/$(STYLE_STYL) -o $(BUILD_DIR)/$(STYLE_CSS)
	$(PANDOC) --metadata title=$(TITLE) --template $(SRC_DIR)/$(RESUME_TMPL) $(SRC_DIR)/$(RESUME_MD) > $(BUILD_DIR)/$(RESUME_HTML)
	$(PANDOC) $(SRC_DIR)/$(RESUME_MD) -o $(BUILD_DIR)/$(RESUME_PDF)
	$(PANDOC) -s $(SRC_DIR)/$(RESUME_MD) -o $(BUILD_DIR)/$(RESUME_DOCX)

dev: compile
	stalk -w 1 make $(SRC_DIR)&
	$(SERVER)

publish: clean compile
	cd $(BUILD_DIR) && \
	git init && \
	git remote add gh-pages git@github.com:$(GITHUB_USER)/resume.git && \
	git add . && \
	git commit -m 'update resume' && \
	git push -f gh-pages master:gh-pages
	echo "check http://$(GITHUB_USER).github.io/resume/"
