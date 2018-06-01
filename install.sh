#!/bin/bash

## Disable IPv6
grep -q -F 'net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
grep -q -F 'net.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
grep -q -F 'net.ipv6.conf.lo.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
sysctl -p

## install initial dependencies
apt-get update
apt-get install -y --reinstall software-properties-common

## add repository keys
add-apt-repository -y "deb http://ports.ubuntu.com/ubuntu-ports xenial-updates InRelease main"
add-apt-repository -y "deb http://ports.ubuntu.com xenial-updates InRelease main"
add-apt-repository -y ppa:ansible/ansible

## add more dependencies
apt-get update
apt-get install -y --reinstall \
    git \
    build-essential \
    unzip \
    wget \
    curl \
    dialog \
    whiptail \
    ansible \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    python-dev \
    python-pip 
python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall pip==9.0.3
python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall setuptools
python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    pyOpenSSL \
    requests \
    netaddr
python -m pip install --disable-pip-version-check --upgrade --force-reinstall pip==9.0.3
python -m pip install --disable-pip-version-check --upgrade --force-reinstall setuptools
python -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    pyOpenSSL \
    requests \
    netaddr

## copy pip
cp /usr/local/bin/pip /usr/bin/pip
cp /usr/local/bin/pip3 /usr/bin/pip3

## download armada
rm -r /opt/armada
git clone https://github.com/etorr/armada /opt/armada

## install armada
cd /opt/armada
ansible-playbook armada.yml --tags armhf

