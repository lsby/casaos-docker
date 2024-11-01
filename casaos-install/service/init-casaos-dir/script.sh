#!/bin/bash
echo "Running init casaos dir..."

if [ -z "$(ls -A /var/lib/casaos/www)" ]; then
    echo "/var/lib/casaos/www is empty. Copying files from /var/lib/casaos-bak"
    cp -r /var/lib/casaos-bak/. /var/lib/casaos/
fi
