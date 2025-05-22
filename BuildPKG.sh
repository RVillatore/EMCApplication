#!/bin/bash
set -e

# Setup environment
cd /machinekit/emca

# Update package lists with retries
for i in {1..3}; do
    sudo apt-get update && break
    sleep 5
done

# Build steps
export PKG_CONFIG_PATH=/machinekit/emca/
sudo update-alternatives --set fakeroot /usr/bin/fakeroot-tcp
./debian/configure machinekit-hal=0.5.21099-1.git2c2ff0e51~bullseye no-docs
mk-build-deps --remove --root-cmd sudo --tool 'apt-cudf-get --solver aspcud -o APT::Get::Assume-Yes=1 -o Debug::pkgProblemResolver=0 -o APT::Install-Recommends=0' debian/control

# Install dependencies with retries
for i in {1..3}; do
    sudo apt-get install -y ./*.deb && break
    sleep 5
done

dpkg-buildpackage -us -uc
cp ../*.deb .
