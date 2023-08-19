ANSIBLE_VIRTUALENV ?= .venv
ANSIBLE_PYTHON := . $(ANSIBLE_VIRTUALENV)/bin/activate && python3
ANSIBLE_PIP := $(ANSIBLE_PYTHON) -m pip
ANSIBLE_LINT := . $(ANSIBLE_VIRTUALENV)/bin/activate && ansible-lint
ANSIBLE_GALAXY := . $(ANSIBLE_VIRTUALENV)/bin/activate && ansible-galaxy

.PHONY: help
help: ## Brief overview of available targets and their descriptions
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Clean up the build artifacts, object files, executables, and any other generated files
	rm -rf $(ANSIBLE_VIRTUALENV) *.tar.gz

$(ANSIBLE_VIRTUALENV):
	python3 -m venv $(ANSIBLE_VIRTUALENV)
	$(ANSIBLE_PIP) install 'setuptools>=45.0.0' wheel
	$(ANSIBLE_PIP) install -r requirements.txt

.PHONY: format
format: $(ANSIBLE_VIRTUALENV) ## Automatically format the source code
	@$(ANSIBLE_LINT) -v

.PHONY: build
build: format ## Build collection archive
	$(ANSIBLE_GALAXY) collection build --force

.PHONY: release
release: clean build ## Publish collection
	$(ANSIBLE_GALAXY) collection publish *.tar.gz --api-key $(GALAXY_API_KEY)

