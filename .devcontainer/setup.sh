#!/usr/bin/env bash
set -e

echo "=== 1. Syncing Ubuntu System Packages ==="
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
    wget \
    tar \
    bzip2 \
    make \
    git \
    gcc-multilib \
    g++-multilib \
    ca-certificates

echo "=== 2. Downloading & Extracting ARM GCC 10.3.1 ==="
cd /tmp
wget --no-check-certificate -q https://arm.com

echo "Unpacking toolchain binaries directly into system libraries..."
sudo tar -xjf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -C /usr/local --strip-components=1
rm gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2

echo "=== 3. Provisioning VEX PROS Command Line Tools ==="
python3 -m pip install --user --upgrade pip
python3 -m pip install --user pros-cli

echo "=== 4. Sanity Checking Global Executables ==="
arm-none-eabi-gcc --version
pros --version

echo "Container configuration finalized successfully."
