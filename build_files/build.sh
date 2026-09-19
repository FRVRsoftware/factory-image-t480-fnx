#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux

# test suite
dnf5 install -y sysbench
dnf5 -y install gdb strace --setopt=install_weak_deps=False

# stuff
dnf5 install -y kitty
dnf5 -y install \
  lm_sensors smartmontools stress-ng dmidecode \
  pciutils usbutils inxi powertop \
  glx-utils vulkan-tools edid-decode \
  iw ethtool usbguard \
  --setopt=install_weak_deps=False --skip-unavailable

systemctl enable podman.socket
