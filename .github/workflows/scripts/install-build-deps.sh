#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/init-env.sh"

OS=$(uname -s)
case "$OS" in
  Darwin*)
    RUNNER=${1:-"macos-13"}
    ls -al /Library/Developer/CommandLineTools/SDKs/
    xcrun --show-sdk-path
    [ -n "$LLVM_REPO" ] && wget --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 -t 5 --no-verbose "$LLVM_REPO/releases/download/llvm-${LLVM_VERSION}-ispc-dev/${LLVM_TAR}"
    tar xf "$LLVM_TAR"
    echo "${GITHUB_WORKSPACE}/bin-${LLVM_VERSION}/bin" >> "$GITHUB_PATH"
    brew install bison flex
    if [ "$RUNNER" == "macos-14" ]; then
      echo "/opt/homebrew/opt/bison/bin" >> "$GITHUB_PATH"
      echo "/opt/homebrew/opt/flex/bin" >> "$GITHUB_PATH"
    else
      echo "/usr/local/opt/bison/bin" >> "$GITHUB_PATH"
      echo "/usr/local/opt/flex/bin" >> "$GITHUB_PATH"
    fi
    exit 0
    ;;
esac

echo "APT::Acquire::Retries \"3\";" | sudo tee -a /etc/apt/apt.conf.d/80-retries

# Detect system architecture
if [[ $(uname -m) =~ "x86" ]]; then
    CROSS_LIBS=("libc6-dev-i386" "g++-multilib" "lib32stdc++6")
else
    CROSS_LIBS=("libc6-dev-armhf-cross")
fi

# if apt-get fails, retry several time.
for i in {1..5}
do
  sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y && sudo apt-get -y update | tee log${i}.txt
  sudo apt-get install ninja-build bison flex libtbb-dev libstdc++6 "${CROSS_LIBS[@]}" | tee -a log${i}.txt
  sudo apt install python3-pip python3-dev
  pip3 install nanobind numpy
  if [[ ! `grep "^Err: " log${i}.txt` && ! `grep "^E: " log${i}.txt` ]]; then
    echo "APT packages installation was successful"
    break
  else
    if [[ ${i} -eq 5 ]]; then
      echo "APT had unrecoverable errors, exiting"
      exit 1
    else
      sleep_time=$((${i} * 10))
      echo "APT packages installation failed, sleeping ${sleep_time} seconds"
      sleep ${sleep_time}
      sudo rm -rf /var/lib/apt/lists/*
    fi
  fi
done

# Check if both SDE_MIRROR_ID and USER_AGENT are defined
if [ -n "$SDE_MIRROR_ID" ] && [ -n "$USER_AGENT" ]; then
    echo -U "$USER_AGENT" --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 -t 5 https://downloadmirror.intel.com/"$SDE_MIRROR_ID"/"$SDE_TAR_NAME"-lin.tar.xz
    wget -q -U "$USER_AGENT" --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 -t 5 https://downloadmirror.intel.com/"$SDE_MIRROR_ID"/"$SDE_TAR_NAME"-lin.tar.xz
    tar xf "$SDE_TAR_NAME"-lin.tar.xz
else
    echo "SDE_MIRROR_ID and/or USER_AGENT are not defined. Skipping download."
fi

if [ -n "$INSTALL_COMPUTE_RUNTIME" ]; then
    if [ -n "$COMPUTE_RUNTIME_GITHUB_RELEASE" ]; then
        echo "install Compute Runtime from GitHub release page"
        SCRIPTS_DIR=$(cd "$(dirname "$0")" && pwd)
        "$SCRIPTS_DIR/install-compute-runtime.sh"
    else
        echo "install Compute Runtime"
        wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | sudo gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
        echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu jammy unified' > /tmp/intel.gpu.focal.list
        sudo mv /tmp/intel.gpu.focal.list /etc/apt/sources.list.d/
        sudo apt-get -y update
        sudo apt-get --no-install-recommends install -y intel-opencl-icd \
            intel-media-va-driver-non-free libmfx1 libmfxgen1 libvpl2 \
            libegl-mesa0 libegl1-mesa libegl1-mesa-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri \
            libglapi-mesa libgles2-mesa-dev libglx-mesa0 libigdgmm12 libxatracker2 mesa-va-drivers \
            mesa-vdpau-drivers mesa-vulkan-drivers va-driver-all
    fi
fi

[ -n "$LLVM_REPO" ] && wget -q --retry-connrefused --waitretry=5 --read-timeout=20 --timeout=15 -t 5 $LLVM_REPO/releases/download/llvm-$LLVM_VERSION-ispc-dev/$LLVM_TAR
tar xf $LLVM_TAR
if [ -n "$SDE_MIRROR_ID" ] && [ -n "$USER_AGENT" ]; then
  echo "${GITHUB_WORKSPACE}/$SDE_TAR_NAME-lin" >> $GITHUB_PATH
fi
echo "${GITHUB_WORKSPACE}/bin-$LLVM_VERSION/bin" >> $GITHUB_PATH
