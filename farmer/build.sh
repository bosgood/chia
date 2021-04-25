#!/bin/bash

# Build the Ignition config file using the Fedora CoreOS transpiler
docker run --rm --tty --interactive \
  --security-opt label=disable \
  --volume "${PWD}/farmer:/code" \
  --workdir /code \
  quay.io/coreos/butane:release \
  ignition.yaml \
  --strict \
  -o ignition.json

# Escape quotes in rendered JSON and set as Terraform variable
ign="$(sed 's/"/\\"/g' < farmer/ignition.json | sed 's/ *//g')"
echo "farmer_user_data = \"${ign}\"" > terraform/instance.private.tfvars
