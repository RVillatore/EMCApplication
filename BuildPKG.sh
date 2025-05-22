#!/bin/bash
set -e

# Setup environment
cd /machinekit/emca

# Setup cloudsmith sources using proper key management
sudo curl -fsSL -o /etc/apt/trusted.gpg.d/machinekit-cloudsmith.gpg \
    "https://dl.cloudsmith.io/public/machinekit/machinekit/gpg.70528471A8369D24.key"
sudo curl -fsSL -o /etc/apt/trusted.gpg.d/machinekit-hal-cloudsmith.gpg \
    "https://dl.cloudsmith.io/public/machinekit/machinekit-hal/gpg.70528471A8369D24.key"

echo "deb [arch=armhf] https://dl.cloudsmith.io/public/machinekit/machinekit/debian/ubuntu bullseye main" | \
    sudo tee /etc/apt/sources.list.d/machinekit.list
echo "deb [arch=armhf] https://dl.cloudsmith.io/public/machinekit/machinekit-hal/debian/ubuntu bullseye main" | \
    sudo tee /etc/apt/sources.list.d/machinekit-hal.list

# Update package lists
sudo apt-get update

# Build steps
export PKG_CONFIG_PATH=/machinekit/emca/
sudo update-alternatives --set fakeroot /usr/bin/fakeroot-tcp
./debian/configure machinekit-hal=0.5.21099-1.git2c2ff0e51~bullseye no-docs
mk-build-deps --remove --root-cmd sudo --tool 'apt-cudf-get --solver aspcud -o APT::Get::Assume-Yes=1 -o Debug::pkgProblemResolver=0 -o APT::Install-Recommends=0' debian/control
sudo apt-get install -y ./*.deb
dpkg-buildpackage -us -uc
cp ../*.deb .
