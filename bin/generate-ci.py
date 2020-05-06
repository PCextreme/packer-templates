from jinja2 import Environment, FileSystemLoader, StrictUndefined
import json
import base64
import argparse
import yaml


def generator(config, bucket):
    j2 = Environment(loader=FileSystemLoader("tpl"), undefined=StrictUndefined)
    tpl = j2.get_template("gitlab-ci_deploy.yml.jinja")

    # Load the cloudstack profiles
    # We only need their names, as the previous job has already generated the files.
    profiles = []
    for profile in json.loads(base64.b64decode(config)):
        profiles.append(config["name"])

    # Load the parent .gitlab-ci.yml and gather all the jobs we need to generate child pipelines for.
    with open(".gitlab-ci.yml", "r") as f:
        jobs = yaml.safe_load(f)

        names = []
        for k, v in jobs.items():
            # We want jobs in the 'deploy' stage
            if k.startswith("deploy:"):
                # The template follows after this, so strip the stage.
                names.append(k.replace("deploy:", '', maxreplace=1))

    # Every entry has some corresponding files we need the get info from
    for name in names:

        # The Packer generated manifest contains custom template data.
        # We pass this additional info to our register script where it get's added as tags on the template.
        with open("build_{}/{}.json".format(name), "r") as f:
            manifest = json.loads(f.read())

            # Get the ID of the packer run for future reference
            run_uuid = manifest["builds"][0]["packer_run_uuid"]

            # We don't need anything besides the custom data
            manifest = manifest["builds"][0]["custom_data"]
            manifest.update(build=run_uuid)

            # Since we need to pass this on the CLI, we dump the json again and base64 encode it.
            manifest = base64.b64encode(json.dumps(manifest))

        # Packer also calculates a checksum for the template
        # Since we want to use SHA256 the string needs to be prefixed for Cloudstack
        with open("build_{}/{}.checksum".format(name), "r") as f:
            checksum = f.read()
            checksum = "{<SHA-256>}" + checksum.split()[0]

        with open(".gitlab-ci_deploy.yml".format(name), "a+") as f:
            f.write(
                tpl.render(
                    name=name,
                    profiles=profiles,
                    manifest=manifest,
                    bucket=bucket,
                    checksum=checksum,
                )
            )


if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Generate Gitlab CI jobs")

    p.add_argument("--bucket", help="Location of the template (S3 bucket)")
    p.add_argument("--config", help="Base64 encoded config payload")
    args = p.parse_args()

    generator(*args)
