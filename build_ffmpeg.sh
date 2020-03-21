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

ENABLED_ENCODERS=(h264 png)
ENABLED_DECODERS=(h264 png)
ENABLED_MUXERS=(h264 mp4 3gp webm matroska avi image2)
ENABLED_DEMUXERS=(webm matroska concat)

COMMON_OPTIONS="
    --target-os=android
    --disable-static
    --enable-shared
    --disable-doc
    --disable-programs
    --disable-everything
    --disable-avdevice
    --disable-postproc
    --disable-symver
    --enable-swscale
    --enable-avformat
    --enable-avfilter
    --enable-avresample
    --enable-swresample
    "
TOOLCHAIN_PREFIX="${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}/bin"
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
cd "${FFMPEG_PATH}"
 (git -C ffmpeg pull || git clone git://source.ffmpeg.org/ffmpeg ffmpeg)
cd ffmpeg
git checkout release/4.2

# armeabi-v7a
./configure \
    --prefix=android-libs/armeabi-v7a \
    --arch=arm \
    --cpu=armv7-a \
    --cross-prefix="${TOOLCHAIN_PREFIX}/armv7a-linux-androideabi16-" \
    --nm="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-nm" \
    --strip="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-strip" \
    --extra-cflags="-march=armv7-a -mfloat-abi=softfp" \
    --extra-ldflags="-Wl,--fix-cortex-a8" \
    --extra-ldexeflags=-pie \
    ${COMMON_OPTIONS}
make -j4
make install
make clean

# arm64-v8a
./configure \
    --prefix=android-libs/arm64-v8a \
    --arch=aarch64 \
    --cpu=armv8-a \
    --cross-prefix="${TOOLCHAIN_PREFIX}/aarch64-linux-android21-" \
    --nm="${TOOLCHAIN_PREFIX}/aarch64-linux-android-nm" \
    --strip="${TOOLCHAIN_PREFIX}/aarch64-linux-android-strip" \
    --extra-ldexeflags=-pie \
    ${COMMON_OPTIONS}
make -j4
make install
make clean

# x86
./configure \
    --prefix=android-libs/x86 \
    --arch=x86 \
    --cpu=i686 \
    --cross-prefix="${TOOLCHAIN_PREFIX}/i686-linux-android16-" \
    --nm="${TOOLCHAIN_PREFIX}/i686-linux-android-nm" \
    --strip="${TOOLCHAIN_PREFIX}/i686-linux-android-strip" \
    --extra-ldexeflags=-pie \
    --disable-asm \
    ${COMMON_OPTIONS}
make -j4
make install
make clean
