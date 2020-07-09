TEMPLATE_DIR=templates
BUILD_DIR_PREFIX=build_

.PHONY: build pyenv setup dev

default:
	@echo 'Usage:'
	@echo ' build NAME=template_name  	Build given template with Packer'
	@echo ' setup 						Setup the project'
	@echo ' pyenv 						Setup isolated python env'
	@echo ' dev 						Setup development environment'

build:
	packer build -var-file=${TEMPLATE_DIR}/${NAME}.json -var "name=${NAME}" ${TEMPLATE_DIR}/base.json

pyenv:
	pyenv install -s

setup:
	python -m pip install pipx
	python -m pipx ensurepath
	pipx install poetry
	poetry env info

dev: pyenv setup
