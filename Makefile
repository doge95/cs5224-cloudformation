# Setup variables
NAME = ecommerce-platform
PYENV := $(shell which pyenv)
JQ := $(shell which jq)
PYTHON_VERSION = 3.9.7
MAKEOPTS += -j4

# Service variables
SERVICES = $(shell tools/services 2>/dev/null)
SERVICES_ENVONLY = $(shell tools/services --env-only 2>/dev/null)
export DOMAIN ?= ecommerce
export ENVIRONMENT ?= dev

# Colors
ccblue = \033[0;96m
ccend = \033[0m


# Build services
build: $(foreach service,${SERVICES}, build-${service})
build-%:
	@echo "[*] $(ccblue)build $*$(ccend)"
	@${MAKE} -C $* build

# Clean services
clean: $(foreach service,${SERVICES}, clean-${service})
clean-%:
	@echo "[*] $(ccblue)clean $*$(ccend)"
	@${MAKE} -C $* clean

deploy: $(foreach service,${SERVICES_ENVONLY}, deploy-${service})
deploy-%:
	@echo "[*] $(ccblue)deploy $*$(ccend)"
	@${MAKE} -C $* deploy

# Package services
package: $(foreach service,${SERVICES_ENVONLY}, package-${service})
package-%:
	@echo "[*] $(ccblue)package $*$(ccend)"
	@${MAKE} -C $* package

# Teardown services
teardown:
	@for service_line in $(shell tools/services --graph --reverse --env-only); do \
		${MAKE} ${MAKEOPTS} $$(echo teardown-$$service_line | sed 's/,/ teardown-/g') QUIET=true || exit 1 ; \
	done
teardown-%:
	@echo "[*] $(ccblue)teardown $*$(ccend)"
	@${MAKE} -C $* teardown

#################
# SETUP TARGETS #
#################

# Validate that necessary tools are installed
validate: validate-pyenv validate-jq

# Validate that pyenv is installed
validate-pyenv:
ifndef PYENV
	$(error Make sure pyenv is accessible in your path. You can install pyenv by following the instructions at 'https://github.com/pyenv/pyenv-installer'.)
endif
ifndef PYENV_SHELL
	$(error Add 'pyenv init' to your shell to enable shims and autocompletion.)
endif
ifndef PYENV_VIRTUALENV_INIT
	$(error Add 'pyenv virtualenv-init' to your shell to enable shims and autocompletion.)
endif

# Validate that jq is installed
validate-jq:
ifndef JQ
	$(error 'jq' not found. You can install jq by following the instructions at 'https://stedolan.github.io/jq/download/'.)
endif

# setup: configure tools
setup: validate
	@echo "[*] Download and install python $(PYTHON_VERSION)"
	@pyenv install $(PYTHON_VERSION)
	@pyenv local $(PYTHON_VERSION)
	@echo "[*] Create virtualenv $(NAME) using python $(PYTHON_VERSION)"
	@pyenv virtualenv $(PYTHON_VERSION) $(NAME)
	@$(MAKE) activate
	@$(MAKE) requirements
	@$(MAKE) npm-install

# Activate the virtual environment
activate: validate-pyenv
	@echo "[*] Activate virtualenv $(NAME)"
	$(shell eval "$$(pyenv init -)" && eval "$$(pyenv virtualenv-init -)" && pyenv activate $(NAME) && pyenv local $(NAME))

# Install python dependencies
requirements:
	@echo "[*] Install Python requirements"
	@pip install -r requirements.txt

# Install npm dependencies
npm-install:
	@echo "[*] Install NPM tools"
	@npm install -g speccy
