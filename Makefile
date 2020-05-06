TEMPLATE_DIR=templates
BUILD_DIR_PREFIX=build_

.PHONY: build

default:
	@echo 'Usage:'
	@echo '	make build NAME=template_name	Build given template with Packer'

build:
	packer build -var-file=${TEMPLATE_DIR}/${NAME}.json -var "name=${NAME}" ${TEMPLATE_DIR}/base.json
