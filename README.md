# Packer Templates
This repository contains configurations and scripts to build templates to be used in [AuroraCompute](https://www.pcextreme.nl/aurora/compute).

These are Linux or *BSD based templates which can be generated using [Packer.io](https://packer.io/).

Packer version >= 0.12.1 is required

## Usage
Run `./build.sh <template>` to build a template

All templates can be found in `templates/` directory.

## Examples
To build a single template:

```
$ ./build.sh ubuntu1604
```

To build all templates:

```
$ find templates/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n"|xargs -n 1 ./build.sh
```

## Requirements
Make sure that `packer`, `qemu-img`, `qemu-system` and `virt-resize` are installed. Packer can be obtained from [Packer.io](https://packer.io/). Unzip and place in `/usr/local/sbin` or `~/sbin`.

## Downloads
At PCextreme we use [Gitlab CI](https://gitlab.com/) to automatically build the templates from this Git repository.

The results are afterwards uploaded to [AuroraObjects](https://www.pcextreme.com/aurora/objects) from where they are available to download.

Take the Ubuntu 16.04 template for example, both the 20G, 50G and 100G version can be downloaded:

* http://packer-temlates.o.auroraobjects.eu/ubuntu1604-20G.qcow2
* http://packer-templates.o.auroraobjects.eu/ubuntu1604-50G.qcow2
* http://packer-templates.o.auroraobjects.eu/ubuntu1604-100G.qcow2

You can replace *ubuntu1604* by any directory found in the *templates* directory.

## License
Apache License. Please see [License File](LICENSE) for more information.
