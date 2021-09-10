#! /usr/bin/env -S bash -ex

if [ -z "${1}" ]; then
    echo "Please pass privkey to be base64 encoded."
    exit 1
fi

echo -en 'ED25519-V3:' > onion_v3_private_key.new
dd if="${1}" bs=1 skip=32 | base64 -w0 >> onion_v3_private_key.new

echo "Done!"

