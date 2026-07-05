#!/usr/bin/env bash
set -e

ARM_VER="13.3.rel1"
ARM_PKG="arm-gnu-toolchain-${ARM_VER}-x86_64-arm-none-eabi"
ARM_DIR="/opt/${ARM_PKG}"
ARM_URL="https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_VER}/binrel/${ARM_PKG}.tar.xz"

echo "=== 1. Base deps ==="
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends wget xz-utils python3-pip make
# NOTE: do NOT install apt's gcc-arm-none-eabi — it's the old 10.3 that breaks the build.

echo "=== 2. Official ARM GNU toolchain ${ARM_VER} (matches PROS kernel 4.2.2) ==="
if [ ! -x "${ARM_DIR}/bin/arm-none-eabi-gcc" ]; then
  wget -q "${ARM_URL}" -O /tmp/arm.tar.xz
  sudo tar -xf /tmp/arm.tar.xz -C /opt
  rm /tmp/arm.tar.xz
fi
echo "export PATH=\"${ARM_DIR}/bin:\$PATH\"" | sudo tee /etc/profile.d/arm-toolchain.sh >/dev/null
export PATH="${ARM_DIR}/bin:$PATH"

echo "=== 3. PROS CLI (system-wide, on PATH) ==="
sudo pip3 install pros-cli

echo "=== 4. Verify — gcc MUST say 13.3 ==="
arm-none-eabi-gcc --version | head -1
pros --version
echo "Ready — run 'pros make'"