#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# Run this script not via `./generate.sh`, but via `$PWD/generate.sh`.
# Else `nix-shell` will not find this script.

set -euo pipefail

cd -- "$(dirname -- "$BASH_SOURCE[0]")"
#mkdir etherpad-lite
#curl -L https://github.com/ether/etherpad-lite/tarball/master | tar -xz --strip-components=1 -C "etherpad-lite/"
curl https://codeload.github.com/ether/etherpad-lite/tar.gz/master | tar -xz --strip=1 etherpad-lite-master/src
node2nix \
     --strip-optional-dependencies \
     --nodejs-14 \
     --input node-packages.json \
     --output node-packages-generated.nix \
     --composition node-packages.nix \
     --node-env ../../development/node-packages/node-env.nix

rm -rf src
