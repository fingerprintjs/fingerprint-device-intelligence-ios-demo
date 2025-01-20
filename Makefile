.DEFAULT_GOAL := help

.PHONY: help environment homebrew lint

GITHOOKS_DIR := ".githooks"

help:
	@cat $(MAKEFILE_LIST)

environment: homebrew
	git config core.hooksPath $(GITHOOKS_DIR)
	git config hooks.gitleaks true

homebrew:
	@./scripts/install_homebrew_formulae.sh

lint:
	@./scripts/lint_code.sh --strict
