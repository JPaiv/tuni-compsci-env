#!/bin/bash

# Fix SSH directory permissions
chmod 700 ~/.ssh

# Fix permissions for all private keys (files without extensions or known private key names)
find ~/.ssh -type f ! -name "*.pub" ! -name "known_hosts*" ! -name "config" ! -name "authorized_keys" -exec chmod 600 {} \;

# Allow SSH config to be read
if [ -f ~/.ssh/config ]; then
    chmod 600 ~/.ssh/config
fi
