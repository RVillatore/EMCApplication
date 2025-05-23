#!/bin/bash
set -ex

# Setup environment
cd /machinekit/emca

# Install build dependencies
sudo apt-get update

# Build steps
export PKG_CONFIG_PATH="$PWD"
sudo update-alternatives --set fakeroot /usr/bin/fakeroot-tcp

# show where we are
#echo "Script executed from: ${PWD}"

# Show files
#echo "File list current folder: `ls -lah .`"

# Show problem file permissions
#echo "Permissions for problem file before chmod are: `ls -lah ./debian/configure`"

# Fix permissions before configure
sudo chmod 755 debian
#sudo chmod 644 debian/*

# Show problem file permissions
#echo "Permissions for problem file after chmod are: `ls -lah ./debian/configure`"

# Add MK repo
curl -1sLf 'https://dl.cloudsmith.io/public/machinekit/machinekit-hal/setup.deb.sh' | sudo -E bash
curl -1sLf 'https://dl.cloudsmith.io/public/machinekit/machinekit/setup.deb.sh' | sudo -E bash
sudo apt update

# Configure with proper permissions
#./debian/configure machinekit-hal=0.5.21099-1.git2c2ff0e51~bullseye no-docs
./debian/configure machinekit-hal=0.5.21127-1.gitecf488ab8~bullseye no-docs

# Build package
mk-build-deps --remove --root-cmd sudo \
    --tool 'apt-cudf-get --solver aspcud \
    -o APT::Get::Assume-Yes=1 \
    -o Debug::pkgProblemResolver=0 \
    -o APT::Install-Recommends=0' \
    debian/control

#sudo apt install libmachinekit-hal=0.5.21099-1.git2c2ff0e51~bullseye -y
    
sudo apt install ./*.deb -y
rm ./*.deb

dpkg-buildpackage -us -uc
cp ../*.deb .
