MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR := $(dir $(MAKEFILE_PATH))
PYTHON_VENV ?= $(MAKEFILE_DIR)/.venv
PYTHON_BIN := . $(PYTHON_VENV)/bin/activate && python3
PYTHON_PIP := $(PYTHON_BIN) -m pip
ANSIBLE_GALAXY := . $(PYTHON_VENV)/bin/activate && ansible-galaxy
ANSIBLE_LINT := . $(PYTHON_VENV)/bin/activate && ansible-lint
ANSIBLE_MOLECULE := . $(PYTHON_VENV)/bin/activate && molecule

.PHONY: help
help: ## Brief overview of available targets and their descriptions
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Clean up the build artifacts, object files, executables, and any other generated files
	rm -rf $(PYTHON_VENV) *.tar.gz

$(PYTHON_VENV):
	python3 -m venv $(PYTHON_VENV)
	$(PYTHON_PIP) install 'setuptools>=45.0.0' wheel
	$(PYTHON_PIP) install -r requirements.txt

.PHONY: format
format: $(PYTHON_VENV) ## Automatically format the source code
	@$(ANSIBLE_LINT) -v

.PHONY: build
build: format ## Build collection archive
	$(ANSIBLE_GALAXY) collection build --force

ANSIBLE_ROLES := $(shell find roles -mindepth 1 -maxdepth 1 -type d)
$(ANSIBLE_ROLES): $(PYTHON_VENV)
	cd $@ && $(ANSIBLE_MOLECULE) test

.PHONY: test
test: $(PYTHON_VENV) $(ANSIBLE_ROLES) build  ## Run tests
	$(ANSIBLE_GALAXY) collection install *.tar.gz

.PHONY: release
release: clean build ## Publish collection
	$(ANSIBLE_GALAXY) collection publish *.tar.gz --api-key $(GALAXY_API_KEY)
