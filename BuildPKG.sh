#!/bin/bash
set -ex

# Setup environment
cd /machinekit/emca

# Install build dependencies
sudo apt-get update
sudo apt-get build-dep -y .

# Build steps
export PKG_CONFIG_PATH="$PWD"
sudo update-alternatives --set fakeroot /usr/bin/fakeroot-tcp

# Configure with proper permissions
./debian/configure machinekit-hal=0.5.21099-1.git2c2ff0e51~bullseye no-docs

# Build package
mk-build-deps --remove --root-cmd sudo \
    --tool 'apt-cudf-get --solver aspcud \
    -o APT::Get::Assume-Yes=1 \
    -o Debug::pkgProblemResolver=0 \
    -o APT::Install-Recommends=0' \
    debian/control

dpkg-buildpackage -us -uc
cp ../*.deb .
