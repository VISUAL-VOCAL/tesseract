#!/bin/sh

# Set these variables to suit your needs
SOURCE_DIRECTORY="$(dirname $0)"
cd ${SOURCE_DIRECTORY}
PWD=`pwd`
SOURCE_DIRECTORY="${PWD}"

BUILD_DIRECTORY_SUFFIX="build/android"
BUILD_DIRECTORY="${SOURCE_DIRECTORY}/${BUILD_DIRECTORY_SUFFIX}"

CONFIGURE_FLAGS="--disable-graphics"

LEPTONICA_PACKAGE_DIRECTORY="${SOURCE_DIRECTORY}/../leptonica/${BUILD_DIRECTORY_SUFFIX}/install/lib/pkgconfig"

NDK_PATH="${SOURCE_DIRECTORY}/../ndk/android-ndk-r18b"
TOOLCHAIN="${SOURCE_DIRECTORY}/../ndk/toolchains/r18b-arm-24"
SYSROOT="${TOOLCHAIN}/sysroot"
BUILD_PLATFORM="linux-x86_64"
TOOLCHAIN_VERSION="4.9"
ANDROID_VERSION="24"

# It should not be necessary to modify the rest
TARGET_HOST=arm-linux-androideabi
ANDROID_CFLAGS="-march=armv7-a -mfloat-abi=softfp --sysroot=${SYSROOT} -D__ANDROID_API__=${ANDROID_VERSION} -DANDROID_BUILD"

ANDROID_INCLUDES="-I${SYSROOT}/usr/include -I${TOOLCHAIN}/lib/gcc/${TARGET_HOST}/${TOOLCHAIN_VERSION}.x/include -I${TOOLCHAIN}/prebuilt_include/clang/include"

export AR=${TOOLCHAIN}/bin/${TARGET_HOST}-ar
export AS=${TOOLCHAIN}/bin/${TARGET_HOST}-clang
export CC=${TOOLCHAIN}/bin/${TARGET_HOST}-clang
export CXX=${TOOLCHAIN}/bin/${TARGET_HOST}-clang++
export LD=${TOOLCHAIN}/bin/${TARGET_HOST}-ld
export STRIP=${TOOLCHAIN}/bin/${TARGET_HOST}-strip

#export RANLIB=${TOOLCHAIN}/bin/${TARGET_HOST}-ranlib
#export NM=${TOOLCHAIN}/bin/${TARGET_HOST}-nm

#export CPP=${TOOLCHAIN}/bin/${TARGET_HOST}-cpp
#export OBJDUMP=${TOOLCHAIN}/bin/${TARGET_HOST}-objdump

export PATH=${PATH}:${TOOLCHAIN}/bin
export NDK=${NDK_PATH}
export ANDROID_NDK_ROOT=${NDK_PATH}
export SYSROOT=${SYSROOT}

export CFLAGS="${INCLUDE_DIRS} ${LIB_DIRS} ${ANDROID_INCLUDES} ${ANDROID_CFLAGS} -O3 -fPIC -fPIE"
export CXXFLAGS="${INCLUDE_DIRS} ${LIB_DIRS} ${ANDROID_INCLUDES} ${ANDROID_CFLAGS} -O3 -fPIC -fPIE"
export CPPFLAGS="${INCLUDE_DIRS} ${LIB_DIRS} ${ANDROID_INCLUDES} ${ANDROID_CFLAGS}"
export ASFLAGS="${INCLUDE_DIRS} ${LIB_DIRS} ${ANDROID_CFLAGS}"
export LDFLAGS="${INCLUDE_DIRS} ${LIB_DIRS} ${ANDROID_CFLAGS} -pie"

export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${LEPTONICA_PACKAGE_DIRECTORY}"

cd ${SOURCE_DIRECTORY}
mkdir --parents ${BUILD_DIRECTORY}
export NOCONFIGURE=1
${SOURCE_DIRECTORY}/autogen.sh
cd ${BUILD_DIRECTORY}

sh ${SOURCE_DIRECTORY}/configure \
  --host=${TARGET_HOST} \
  --prefix=${BUILD_DIRECTORY}/install \
  ${CONFIGURE_FLAGS} \
  CFLAGS="${CFLAGS}" \
  CPPFLAGS="${CPPFLAGS}" \
  LDFLAGS="${LDFLAGS}" \
  LIBS=-lm \
  PKG_CONFIG_PATH="${PKG_CONFIG_PATH}" \
  ${1+"$@"}

make
make install-strip
