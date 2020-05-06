from jinja2 import Environment, FileSystemLoader, StrictUndefined
import json
import base64
import argparse


# config is expected to be a base64 encoded json containing:
# [
#     {
#         "name": "my_manager",
#         "endpoint": "https://cloud/api",
#         "key": "abc",
#         "secret": "xyz"
#     }
# ]
def generator(config):
    j2 = Environment(loader=FileSystemLoader("tpl"), undefined=StrictUndefined)
    tpl = j2.get_template("cloudstack.ini.jinja")

    profiles = json.loads(base64.b64decode(config))

    with open("cloudstack.ini", "w") as f:
        f.write(tpl.render(profiles=profiles))


if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Generate cloudstack.ini config files")

    p.add_argument("--config", help="Base64 encoded config payload")
    args = p.parse_args()

    generator(**args)
