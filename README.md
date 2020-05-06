[![github-readme_header](https://cloud.githubusercontent.com/assets/2406615/17754363/6e205280-64d4-11e6-946d-e7e7aedb2e30.png)](https://www.pcextreme.nl)

# Compute Templates

Packer template source for public templates available on the PCextreme cloud.

## Cloudstack profiles
Uploading to Cloudstack is done with the help of an python CLI wrappen around the API, a profile is needed for this to work.
To keep this (secret) information out of Git while also making it possible to add multiple Cloudstack clusters, this info is fetched from an environment variable: `CLOUDMONKEY_PROFILES`.

This variable should contain the following json encoded as base64, with at least 1 entry.
```json
[
  {
    "name": "mymanager",
    "endpoint": "https://cloud/api",
    "key": "abc",
    "secret": "xyz"
  }
]
```
```bash
% jq '.' profiles.json | base64 -w 0
WwogIHsKICAgICJuYW1lIjogIm15bWFuYWdlciIsCiAgICAiZW5kcG9pbnQiOiAiaHR0cHM6Ly9jbG91ZC9hcGkiLAogICAgImtleSI6ICJhYmMiLAogICAgInNlY3JldCI6ICJ4eXoiCiAgfQpdCg==
```

The config can be generated using [generate-cloudstack](bin/generate-cloudstack), which will append every entry to an ini file that will be used by the [register](bin/register) script.
```ini
[mymanager]
endpoint = https://cloud/api
key = abc
secret = xyz
```

# Licensing
The PCextreme Aurora Templates are licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for the full license text.
