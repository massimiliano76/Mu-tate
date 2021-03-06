XARGS := xargs -0 $(shell test $$(uname) = Linux && echo -r)
GREP_T_FLAG := $(shell test $$(uname) = Linux && echo -T)

all:
	@echo "\nThere is no default Makefile target right now. Try:\n"
	@echo "make ace - check for and download the latest version of Ace editor."
	@echo "make clean - reset the project and remove auto-generated assets."
	@echo "make docs - run sphinx to create project documentation."
	@echo "make python - check for and download the latest stand-alone Python."
	@echo "make run - run the application locally."
	@echo "make setup - setup and install a development environment for Mu."
	@echo "make test - run the jasmine based unit tests."
	@echo "make tidy - tidy project Python code with black."

ace: clean
	python3 utils/get_ace.py

clean:
	rm -rf docs/_build
	rm -rf *.mp4
	rm -rf *.log
	rm -rf .git/avatar/*
	find . \( -name '*.py[co]' -o -name dropin.cache \) -delete
	find . \( -name '*.bak' -o -name dropin.cache \) -delete
	find . \( -name '*.tgz' -o -name dropin.cache \) -delete
	find . | grep -E "(__pycache__)" | xargs rm -rf

docs: clean
	$(MAKE) -C docs html
	@echo "\nDocumentation can be found here:"
	@echo file://`pwd`/docs/_build/html/index.html
	@echo "\n"

python: clean
	python3 utils/get_python.py

run: clean
	npm start --prefix ./mu

setup: clean
	command -v node >/dev/null 2>&1 || { echo >&2 "I require node but it's not installed. Aborting."; exit 1; }
	command -v npm >/dev/null 2>&1 || { echo >&2 "I require npm but it's not installed. Aborting."; exit 1; }
	npm install --prefix ./mu

test: clean
	jasmine ci --config tests/jasmine.yml
	rm *.log

tidy: clean
	@echo "\nTidying code with black..."
	black -l 79 utils
