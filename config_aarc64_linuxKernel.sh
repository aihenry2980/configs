unzip 
https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz

set path
export PATH="/home/jx/Downloads/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/:$PATH"


make ARCH=arm64 CROSS_COMPILE="aarch64-none-linux-gnu-" defconfig
make ARCH=arm64 CROSS_COMPILE="aarch64-none-linux-gnu-"

