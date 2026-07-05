#!/usr/bin/env bash
set -e

echo "Installing core dependencies..."
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    bzip2 \
    make \
    wget \
    tar \
    python3 \
    python3-pip \
    python3-setuptools \
    git \
    gcc-multilib \
    g++-multilib

echo "Installing native ARM GCC 10.3.1 toolchain..."
wget -q https://arm.com
sudo tar -xjf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -C /usr/local --strip-components=1
rm gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2

echo "Installing PROS CLI..."
python3 -m pip install --user --upgrade pip
python3 -m pip install --user pros-cli

echo "Verifying environment configurations:"
arm-none-eabi-gcc --version
pros --version