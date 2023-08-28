### Make ######################################################################
MAKEFILE_DIR := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))

.PHONY: help
help: ## Brief overview of available targets and their descriptions
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

### Ansible ###################################################################
ANSIBLE_GALAXY := ansible-galaxy
ANSIBLE_LINT := ansible-lint
ANSIBLE_MOLECULE := molecule

.PHONY: clean
clean: ## Clean up the build artifacts, object files, executables, and any other generated files
	rm -rf *.tar.gz

.PHONY: format
format: ## Automatically format the source code
	@$(ANSIBLE_LINT) -v

.PHONY: build
build: format ## Build collection archive
	$(ANSIBLE_GALAXY) collection build --force

ANSIBLE_ROLES := $(shell find roles -mindepth 1 -maxdepth 1 -type d)
$(ANSIBLE_ROLES):
	cd $@ && $(ANSIBLE_MOLECULE) test
.PHONY: $(ANSIBLE_ROLES)

.PHONY: test
test: $(ANSIBLE_ROLES)  ## Run tests

.PHONY: install
install: $(PYTHON_VENV) build ## Install collection
	$(ANSIBLE_GALAXY) collection install *.tar.gz

.PHONY: release
release: clean build ## Publish collection
	$(ANSIBLE_GALAXY) collection publish *.tar.gz --api-key $(GALAXY_API_KEY)
