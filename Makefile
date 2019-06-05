include local.mk
include VERSION.mk

#
# root Makefile
#
TARGET  := $(shell basename `pwd`)
PROJECT_NAME?=application

# Create the target lists
SOURCES := $(wildcard ct/*.yaml)
TARGET_DIR := ${DIR}/ct/output/

# Values that are possibly already set
ENVIRONMENT?=dev

CT_TARGETS=(consul gateway)

export # make above variables available in subshells


all:
	@echo ""
	@echo "////"
	@echo "Build ignition files with `make ignition`"
	@echo "////"
	@echo ""

# patsubst to make targets for the output, based on the input names
destfiles := $(patsubst ct/%.yaml,ct/output/%.json,$(SOURCES))
destination: $(destfiles)

# Ignition dependencies will be the target for `ct/output/%.json
ignition: $(destfiles)

# `ct/%.yaml (below) doesn't really do anything, but it helps with target updates and actions
ct/output/%.json: ct/%.yaml
	@[ -d ct/output ] || mkdir ct/output
	@ct < $^ > $@

ct/%.yaml:
	

.PHONY: destination
