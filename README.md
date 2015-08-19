# Packer Templates

This repository contains configurations and scripts to build templates to be used in [AuroraCompute](https://www.pcextreme.nl/aurora/compute).

These are Linux or *BSD based templates which can be generated using [Packer.io](https://packer.io/).

Packer version >= 0.8.5 is required

## Usage

Run `./build.sh` to get the usage info. 

All templates can be found in `templates/` directory.

## Examples

To build a single template:

```
$ ./build.sh ubuntu1404
```

To build all templates:

```
$ ./build.sh --all
```

## Requirements

Make sure that `packer`, `qemu-img` and `qemu-system` are installed. Packer can be obtained from [Packer.io](https://packer.io/). Unzip and place in `/usr/local/sbin` or `~/sbin`.
