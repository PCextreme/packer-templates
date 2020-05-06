from cs import CloudStack, read_config
import argparse
import json
import base64


def register(profile, name, url, checksum, custom_data):

    # The API client
    # While to config file that we are parsing contains multiple regions, we want to use 1 exact match.
    # We select this by passing it's name to the read_config function.
    cs = CloudStack(**read_config(ini_group=profile))

    # To register a template we need to have an `ostypeid`, so we resolve that here
    # All templates are treated equally and use the same type so we just do a static lookup.
    ostype = cs.listOsTypes(description="Other PV Virtio-SCSI (64-bit)")
    ostype = ostype['ostype'][0]['id']

    # Prepare template tags
    # With this we can look up the template without depending on the ID.
    # custom_data is a base64 encoded json, so we first need to decode that.
    data = json.loads(base64.b64decode(custom_data))
    tags = []
    for k, v in data.items():
        item = {
            "key": k,
            "value": v
        }
        tags.append(item)

    # Register the template and keep it's ID so we can find it later
    template = cs.registerTemplate(
        format="qcow2",
        hypervisor="kvm",
        isdynamicallyscalable="true",
        isextractable="true",
        isfeatured="true",
        ispublic="true",
        zoneids="-1",
        ostypeid=ostype,
        displaytext=name,
        name=name,
        url=url,
        checksum=checksum
    )
    template = template['template'][0]['id']

    # Attach tags to template
    cs.createTags(
        resourceids=template,
        resourcetype="Template",
        tags=tags,
    )


if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Cloudstack registerTemplate wrapper")

    p.add_argument("--name", help="Name of the template")
    p.add_argument("--profile", help="Profile name")
    p.add_argument("--url", help="Download URL")
    p.add_argument("--checksum", help="Checksum string")
    p.add_argument("--custom-data", help="Base64 encoded with tags")

    args = p.parse_args()
    register(**args)
