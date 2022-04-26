# Dependencies
# sudo apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo

BUILD_DIRECTORY=./build
BINUTILS_VERSION=2.38
GCC_VERSION=11.3.0

PREFIX="/usr/local/cross"
TARGET=i686-elf

BINUTILS_FILE="$BUILD_DIRECTORY/binutils-$BINUTILS_VERSION.tar.xz"
GCC_FILE="$BUILD_DIRECTORY/gcc-$GCC_VERSION.tar.xz"

BINUTILS_DIR="$BUILD_DIRECTORY/binutils-$BINUTILS_VERSION"
GCC_DIR="$BUILD_DIRECTORY/gcc-$GCC_VERSION"

export PATH="$PREFIX/bin:$PATH"

[ ! -d "$BUILD_DIRECTORY" ] && mkdir "$BUILD_DIRECTORY"

[ ! -f "$BINUTILS_FILE" ] && wget -O "$BINUTILS_FILE" https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.xz
[ ! -f "$GCC_FILE" ] && wget -O "$GCC_FILE" https://ftp.gnu.org/gnu/gcc/gcc-11.3.0/gcc-$GCC_VERSION.tar.xz

[ ! -d "$BINUTILS_DIR" ] && tar xf "$BUILD_DIRECTORY/binutils-$BINUTILS_VERSION.tar.xz" -C "$BUILD_DIRECTORY"
[ ! -d "$GCC_DIR" ] && tar xf "$BUILD_DIRECTORY/gcc-$GCC_VERSION.tar.xz" -C "$BUILD_DIRECTORY"

mkdir "$BUILD_DIRECTORY/build-binutils"
pushd "$BUILD_DIRECTORY/build-binutils"
../binutils-$BINUTILS_VERSION/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j$(nproc)
make install

popd

mkdir "$BUILD_DIRECTORY/build-gcc"
pushd "$BUILD_DIRECTORY/build-gcc"
../gcc-$GCC_VERSION/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c --without-headers
make -j$(nproc) all-gcc
make -j$(nproc) all-target-libgcc
make install-gcc
make install-target-libgcc

popd

echo Add "$PREFIX/bin" to your path to make gcc available globally.

