# Packer Templates

This repository contains configurations and scripts to build templates to be used in AuroraCompute.

These are Linux or *BSD based templates which can be generated using [Packer.io](https://packer.io/).

## Usage

All templates can be found in templates/ directory.

To build a template run for example:

```
$ cd templates/ubuntu1404
$ packer build template.json
```

Make sure that `packer` is installed. It can be obtained from [Packer.io](https://packer.io/). Unzip and place in `/usr/local/bin` or `~/bin`.

You also need `qemu-system`.

Compress image:

```
$ qemu-img convert -c -f qcow2 -O qcow2 <input>.qcow2 <compressed>_`date +%d-%m-%Y`.qcow2
```
