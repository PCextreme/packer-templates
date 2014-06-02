# Packer Templates
This repository contains configurations and scripts to build templates to be used in AuroraCompute.

This are Linux or *BSD based templates which can be generated using the tool 'packer'.

# Usage
All templates can be found in templates/ directory.

To build a template run for example:
$ cd templates/ubuntu1404
$ packer build template.json

Make sure that packer is installed. It can be obtained from http://packer.io/

Unzip and place in /usr/local/bin
