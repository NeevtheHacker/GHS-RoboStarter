#!/usr/bin/env bash
set -e
sudo apt-get update
sudo apt-get install -y gcc-arm-none-eabi
python3 -m pip install --user pros-cli
echo "Toolchain ready — run 'pros make' to build."