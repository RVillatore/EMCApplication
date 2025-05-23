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

# Configure with proper permissions
./debian/configure machinekit-hal=0.5.21099-1.git2c2ff0e51~bullseye no-docs

# Build package
mk-build-deps --remove --root-cmd sudo \
    --tool 'apt-cudf-get --solver aspcud \
    -o APT::Get::Assume-Yes=1 \
    -o Debug::pkgProblemResolver=0 \
    -o APT::Install-Recommends=0' \
    debian/control

sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
# For Debian Stretch, Ubuntu 16.04 and later
keyring_location=/usr/share/keyrings/machinekit-machinekit-hal-archive-keyring.gpg
# For Debian Jessie, Ubuntu 15.10 and earlier
keyring_location=/etc/apt/trusted.gpg.d/machinekit-machinekit-hal.gpg
sudo curl -1sLf 'https://dl.cloudsmith.io/public/machinekit/machinekit-hal/gpg.D35981AB4276AC36.key' | sudo gpg --dearmor >> ${keyring_location}
sudo curl -1sLf 'https://dl.cloudsmith.io/public/machinekit/machinekit-hal/config.deb.txt?distro=ubuntu&codename=xenial&component=main' > /etc/apt/sources.list.d/machinekit-machinekit-hal.list
sudo chmod 644 ${keyring_location}
sudo chmod 644 /etc/apt/sources.list.d/machinekit-machinekit-hal.list
apt-get update

sudo apt install machinekit-hal=0.5.21099-1.git2c2ff0e51~bullseye -y
    
sudo apt install ./*.deb -y

dpkg-buildpackage -us -uc
cp ../*.deb .
