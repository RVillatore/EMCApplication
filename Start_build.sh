#!/bin/bash
dpkg --print-architecture && uname -m
apt update
apt upgrade -y
apt install build-essential fakeroot devscripts equivs sudo curl python lsb-release apt-cudf -y
addgroup machinekit --gid 1000
adduser machinekit --uid 1000 --gid 1000
echo "machinekit ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
chown -R machinekit:machinekit /machinekit
su machinekit
sudo apt install debian-keyring debian-archive-keyring apt-transport-https -y
curl -1sLf \
  'https://dl.cloudsmith.io/public/machinekit/machinekit/setup.deb.sh' \
  | sudo -E bash
curl -1sLf \
  'https://dl.cloudsmith.io/public/machinekit/machinekit-hal/setup.deb.sh' \
  | sudo -E bash
sudo apt update
cd /machinekit/emca
./debian/configure machinekit-hal=0.5.21099-1.git2c2ff0e51~bionic no-docs
mk-build-deps -irs sudo -t 'apt-cudf-get --solver aspcud -o Debug::pkgProblemResolver=0 -o APT::Install-Recommends=0'
dpkg-buildpackage -us -uc