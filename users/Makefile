export DOMAIN ?= ecommerce
export ENVIRONMENT ?= dev
export ROOT ?= $(shell dirname ${CURDIR})
export SERVICE ?= $(shell basename ${CURDIR})

build:
	@${ROOT}/tools/build resources ${SERVICE}
	@${ROOT}/tools/build openapi ${SERVICE}
	@${ROOT}/tools/build python3 ${SERVICE}
	@${ROOT}/tools/build cloudformation ${SERVICE}
.PHONY: build

clean:
	@${ROOT}/tools/clean ${SERVICE}

deploy:
	@${ROOT}/tools/deploy cloudformation ${SERVICE}

package:
	@${ROOT}/tools/package cloudformation ${SERVICE}

teardown:
	@${ROOT}/tools/teardown cloudformation ${SERVICE}
