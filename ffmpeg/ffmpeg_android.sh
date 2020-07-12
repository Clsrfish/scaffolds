#!/bin/bash

export TMPDIR=/tmp/ffmpeg_build
if [[ ! -d ${TMPDIR} ]]; then
    mkdir -p ${TMPDIR}
fi
if [[ -d $(pwd)/android ]]; then
    rm -r $(pwd)/android
fi
echo $(uname)
if [[ $(uname) == "Darwin" ]]; then
    export HOST=darwin-x86_64
elif [[ $(uname) == "Linux" ]]; then
    export HOST=linux-x86_64
else
    echo "Unsupported host:$(uname)"
    exit 1
fi
NDK_VERSION=""
echo "Input a number to choose the target NDK version or exit:"
select choice in $(ls ${ANDROID_HOME}/ndk) "Quit"; do
    if [[ ${choice} == "Quit" ]]; then
        echo "Quit."
        exit 0
    elif [[ -z ${choice} ]]; then
        echo "Invalid choice, please try again."
    else
        NDK_VERSION=${choice}
        break
    fi
done
export NDK=${ANDROID_HOME}/ndk/${NDK_VERSION}
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/${HOST}/
SYSROOT=${TOOLCHAIN}/sysroot
API=29

function build_ffmpeg() {
    echo "Compiling FFmpeg for ${CPU}"

    ./configure \
        --prefix=${PREFIX} \
        --disable-programs \
        --disable-doc \
        --disable-debug \
        --disable-stripping \
        --disable-static \
        --disable-symver \
        --disable-postproc \
        --disable-avdevice \
        --disable-devices \
        --disable-indevs \
        --disable-outdevs \
        --enable-pic \
        --enable-asm \
        --enable-yasm \
        --enable-neon \
        --enable-small \
        --enable-shared \
        --enable-hwaccels \
        --enable-gpl \
        --enable-jni \
        --enable-mediacodec \
        --enable-decoder=h264_mediacodec \
        --cross-prefix=${CROSS_PREFIX} \
        --target-os=android \
        --arch=${ARCH} \
        --cpu=${CPU} \
        --cc=${CC} \
        --cxx=${CXX} \
        --enable-cross-compile \
        --sysroot=${SYSROOT} \
        --extra-cflags="-Os -fPIC ${OPTIMIZE_CFLAGS}" \
        --extra-ldflags="$OPTIMIZE_CFLAGS" \
        ${ADDITIONAL_CONFIGURE_FLAG}
    make clean
    make -j8
    make install

    echo "The Compilation of FFmpeg for ${CPU} is completed"
}

#armv8-a
ARCH=arm64
CPU=armv8-a
ARCH_ABI=arm64-v8a
CC=${TOOLCHAIN}/bin/aarch64-linux-android${API}-clang
CXX=${TOOLCHAIN}/bin/aarch64-linux-android${API}-clang++
CROSS_PREFIX=${TOOLCHAIN}/bin/aarch64-linux-android-
PREFIX=$(pwd)/android/${ARCH_ABI}
OPTIMIZE_CFLAGS="-march=${CPU} -DANDROID -D__ARMEL__"
build_ffmpeg

#armv7-a
ARCH=arm
CPU=armv7-a
ARCH_ABI=armeabi-v7a
CC=${TOOLCHAIN}/bin/armv7a-linux-androideabi${API}-clang
CXX=${TOOLCHAIN}/bin/armv7a-linux-androideabi${API}-clang++
CROSS_PREFIX=${TOOLCHAIN}/bin/arm-linux-androideabi-
PREFIX=$(pwd)/android/${ARCH_ABI}
OPTIMIZE_CFLAGS="-march=${CPU} -DANDROID -D__ARMEL__ -mfloat-abi=softfp -mfpu=neon -marm"
build_ffmpeg

#x86
ARCH=x86
CPU=x86
ARCH_ABI=${CPU}
CC=${TOOLCHAIN}/bin/i686-linux-android${API}-clang
CXX=${TOOLCHAIN}/bin/i686-linux-android${API}-clang++
CROSS_PREFIX=${TOOLCHAIN}/bin/i686-linux-android-
PREFIX=$(pwd)/android/${ARCH_ABI}
OPTIMIZE_CFLAGS="-march=i686 -DANDROID -mssse3 -m32 -mtune=intel -mfpmath=sse"
ADDITIONAL_CONFIGURE_FLAG="--disable-asm"
build_ffmpeg

#x86_64
ARCH=x86_64
CPU=x86-64
ARCH_ABI=${ARCH}
CC=${TOOLCHAIN}/bin/x86_64-linux-android${API}-clang
CXX=${TOOLCHAIN}/bin/x86_64-linux-android${API}-clang++
CROSS_PREFIX=${TOOLCHAIN}/bin/x86_64-linux-android-
PREFIX=$(pwd)/android/${ARCH_ABI}
OPTIMIZE_CFLAGS="-march=${CPU} -DANDROID -msse4.2 -m64 -mtune=intel -mpopcnt"
ADDITIONAL_CONFIGURE_FLAG=""
build_ffmpeg
