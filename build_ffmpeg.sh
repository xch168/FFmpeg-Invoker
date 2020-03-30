#!/bin/bash
#
# Copyright (C) 2019 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FFMPEG_PATH=.
NDK_PATH=/Users/xch/Library/Android/sdk/ndk/21.0.5935234
HOST_PLATFORM="darwin-x86_64"
TOOLCHAIN_PREFIX="${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}/bin"

ENABLED_ENCODERS=(h264 png)
ENABLED_DECODERS=(h264 mpeg4 png)
ENABLED_MUXERS=(h264 mp4 3gp webm matroska avi image2)
ENABLED_DEMUXERS=(webm matroska concat)
ENABLED_PROTOCOLS=(file)
ENABLED_FILTERS=(scale)

COMMON_OPTIONS="
    --target-os=android
    --enable-static
    --disable-shared
    --disable-doc
    --disable-everything
    --disable-programs
    --disable-protocols
    --disable-parsers
    --disable-avdevice
    --disable-postproc
    --disable-symver
    --disable-debug
    "

for encoder in "${ENABLED_ENCODERS[@]}"
do
    COMMON_OPTIONS="${COMMON_OPTIONS} --enable-encoder=${encoder}"
done
for decoder in "${ENABLED_DECODERS[@]}"
do
    COMMON_OPTIONS="${COMMON_OPTIONS} --enable-decoder=${decoder}"
done
for muxer in "${ENABLED_MUXERS[@]}"
do
    COMMON_OPTIONS="${COMMON_OPTIONS} --enable-muxer=${muxer}"
done
for demuxer in "${ENABLED_DEMUXERS[@]}"
do
    COMMON_OPTIONS="${COMMON_OPTIONS} --enable-demuxer=${demuxer}"
done
for protocol in "${ENABLED_PROTOCOLS[@]}"
do
    COMMON_OPTIONS="${COMMON_OPTIONS} --enable-protocol=${protocol}"
done
for filter in "${ENABLED_FILTERS[@]}"
do
    COMMON_OPTIONS="${COMMON_OPTIONS} --enable-filter=${filter}"
done

cd "${FFMPEG_PATH}"
# (git -C ffmpeg pull || git clone git://source.ffmpeg.org/ffmpeg ffmpeg)
cd ffmpeg
git checkout release/4.2

# armeabi-v7a
./configure \
    --prefix=android-libs/armeabi-v7a \
    --arch=arm \
    --cpu=armv7-a \
    --cross-prefix="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-" \
    --nm="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-nm" \
    --cc="${TOOLCHAIN_PREFIX}/armv7a-linux-androideabi16-clang" \
    --ar="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-ar" \
    --extra-cflags="-march=armv7-a -mfloat-abi=softfp" \
    --extra-ldflags="-Wl,--fix-cortex-a8" \
    --extra-ldexeflags=-pie \
    ${COMMON_OPTIONS}
make -j4
make install

SYSROOT="${NDK_PATH}/platforms/android-16/arch-arm"
PREFIX="$(pwd)/android-libs/armeabi-v7a"

# 打包
${TOOLCHAIN_PREFIX}/arm-linux-androideabi-ld \
    -rpath-link=$SYSROOT/usr/lib \
    -L$SYSROOT/usr/lib \
    -L$PREFIX/lib \
    -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
    $PREFIX/libffmpeg.so \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswresample/libswresample.a \
    libswscale/libswscale.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
    ${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}/lib/gcc/arm-linux-androideabi/4.9.x/libgcc_real.a \

${TOOLCHAIN_PREFIX}/arm-linux-androideabi-strip  $PREFIX/libffmpeg.so
make clean

# arm64-v8a
./configure \
    --prefix=android-libs/arm64-v8a \
    --arch=aarch64 \
    --cpu=armv8-a \
    --cross-prefix="${TOOLCHAIN_PREFIX}/aarch64-linux-android-" \
    --nm="${TOOLCHAIN_PREFIX}/aarch64-linux-android-nm" \
    --cc="${TOOLCHAIN_PREFIX}/aarch64-linux-android21-clang" \
    --ar="${TOOLCHAIN_PREFIX}/aarch64-linux-android-ar" \
    --extra-ldexeflags=-pie \
    ${COMMON_OPTIONS}
make -j8
make install

SYSROOT="${NDK_PATH}/platforms/android-21/arch-arm64"
PREFIX="$(pwd)/android-libs/arm64-v8a"

 # 打包
${TOOLCHAIN_PREFIX}/aarch64-linux-android-ld \
    -rpath-link=$SYSROOT/usr/lib \
    -L$SYSROOT/usr/lib \
    -L$PREFIX/lib \
    -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
    $PREFIX/libffmpeg.so \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswresample/libswresample.a \
    libswscale/libswscale.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
    ${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}/lib/gcc/aarch64-linux-android/4.9.x/libgcc_real.a \

${TOOLCHAIN_PREFIX}/aarch64-linux-android-strip  $PREFIX/libffmpeg.so
make clean

# x86
./configure \
    --prefix=android-libs/x86 \
    --arch=x86 \
    --cpu=i686 \
    --cross-prefix="${TOOLCHAIN_PREFIX}/i686-linux-android-" \
    --nm="${TOOLCHAIN_PREFIX}/i686-linux-android-nm" \
    --cc="${TOOLCHAIN_PREFIX}/i686-linux-android16-clang" \
    --ar="${TOOLCHAIN_PREFIX}/i686-linux-android-ar" \
    --extra-ldexeflags=-pie \
    --disable-asm \
    ${COMMON_OPTIONS}
make -j4
make install

SYSROOT="${NDK_PATH}/platforms/android-16/arch-x86"
PREFIX="$(pwd)/android-libs/x86"

${TOOLCHAIN_PREFIX}/i686-linux-android-ld \
    -rpath-link=$SYSROOT/usr/lib \
    -L$SYSROOT/usr/lib \
    -L$PREFIX/lib \
    -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
    $PREFIX/libffmpeg.so \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswresample/libswresample.a \
    libswscale/libswscale.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
    ${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}/lib/gcc/i686-linux-android/4.9.x/libgcc_real.a \

${TOOLCHAIN_PREFIX}/i686-linux-android-strip  $PREFIX/libffmpeg.so
make clean
