#!/usr/bin/env bash
set -e

echo "=== 1. Syncing Essential Build Tools ==="
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
    wget tar bzip2 unzip make git gcc-multilib g++-multilib python3 python3-pip

echo "=== 2. Creating VS Code Extension Isolation Paths ==="
# Map exact destination targets matching the official extension path mappings
PROS_STORAGE_DIR="$HOME/.vscode-server/data/User/globalStorage/sigbots.pros/install"
mkdir -p "$PROS_STORAGE_DIR/pros-toolchain-linux"
mkdir -p "$PROS_STORAGE_DIR/pros-cli-linux"

echo "=== 3. Pre-Seeding GNU ARM GCC 10.3.1 ==="
cd /tmp
wget -q https://arm.com
tar -xjf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -C "$PROS_STORAGE_DIR/pros-toolchain-linux" --strip-components=1
rm gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2

echo "=== 4. Pre-Seeding PROS CLI (v3.5.6 binary) ==="
wget -q https://github.com
unzip -q pros_cli-3.5.6-lin-64bit.zip -d "$PROS_STORAGE_DIR/pros-cli-linux"
rm pros_cli-3.5.6-lin-64bit.zip
# Make the packed extension binary executable
chmod +x "$PROS_STORAGE_DIR/pros-cli-linux/pros"

echo "=== 5. Injecting Environment Fallbacks ==="
export PATH="$PATH:$PROS_STORAGE_DIR/pros-cli-linux:$PROS_STORAGE_DIR/pros-toolchain-linux/bin"

echo "=== 6. Validating Integrated Executables ==="
pros --version
arm-none-eabi-gcc --version

echo "Pre-seed complete. Environment fully mimics the extension installer."
