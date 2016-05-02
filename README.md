# Packer Templates
This repository contains configurations and scripts to build templates to be used in [AuroraCompute](https://www.pcextreme.nl/aurora/compute).

These are Linux or *BSD based templates which can be generated using [Packer.io](https://packer.io/).

Packer version >= 0.8.5 is required

## Usage
Run `./build.sh -h` to get the usage info.

All templates can be found in `templates/` directory.

## Examples
To build a single template:

```
$ ./build.sh -t ubuntu1404
```

To build all templates:

```
$ ./build.sh -a
```

## Requirements
Make sure that `packer`, `qemu-img` and `qemu-system` are installed. Packer can be obtained from [Packer.io](https://packer.io/). Unzip and place in `/usr/local/sbin` or `~/sbin`.

If you want to use the functionality to upload to S3 you will need to have `s3cmd` installed and configured.

## Downloads
At PCextreme we use [Jenkins](https://jenkins.io/) to automatically build the templates from this Git repository.

The results are afterwards uploaded to [AuroraObjects](https://www.pcextreme.com/aurora/objects) from where they are available to download.

Take the Ubuntu 16.04 template for example, both the 20G and 50G version can be downloaded:

* http://o.auroraobjects.eu/packer20G/ubuntu1604.qcow2
* http://o.auroraobjects.eu/packer50G/ubuntu1604.qcow2

You can replace *ubuntu1604* by any directory found in the *templates* directory.

## License
Apache License. Please see [License File](LICENSE) for more information.
