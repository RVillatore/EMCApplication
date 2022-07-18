#!/bin/bash

sudo apt update
chown -R machinekit:machinekit /machinekit
cd /machinekit/emca
export PKG_CONFIG_PATH=/machinekit/emca
sudo update-alternatives --set fakeroot /usr/bin/fakeroot-tcp
./debian/configure machinekit-hal=0.5.21099-1.git2c2ff0e51~bullseye no-docs
mk-build-deps --remove --root-cmd sudo --tool 'apt-cudf-get --solver aspcud -o APT::Get::Assume-Yes=1 -o Debug::pkgProblemResolver=0 -o APT::Install-Recommends=0' debian/control
sudo apt install ./*.deb -y
dpkg-buildpackage -us -uc
cp ../*.deb .

