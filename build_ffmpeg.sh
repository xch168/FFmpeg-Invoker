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
FFMPEG_PATH=./ffmpeg
FFMPEG_LIB_PATH="$(pwd)/ffmpeg-libs"

USER_HOME=$(eval echo ~$user)
NDK_PATH="$USER_HOME/Library/Android/sdk/ndk/21.0.6113669"
HOST_PLATFORM="darwin-x86_64"
TOOLCHAIN_PREFIX="${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}/bin"
GCC_PREFIX="${NDK_PATH}/toolchains/llvm/prebuilt/${HOST_PLATFORM}/lib/gcc"

git -C ffmpeg pull || git clone git://source.ffmpeg.org/ffmpeg ffmpeg
cd ${FFMPEG_PATH}
git checkout release/4.2

ENABLED_ENCODERS=(png)
ENABLED_DECODERS=(h264 png)
ENABLED_MUXERS=(h264 mp4 matroska image2)
ENABLED_DEMUXERS=(matroska concat rtsp)
ENABLED_PROTOCOLS=(file)
ENABLED_FILTERS=(scale format trim null)

COMMON_OPTIONS="
    --target-os=android
    --enable-small
    --enable-static
    --disable-shared
    --disable-doc
    --disable-everything
    --disable-programs
    --disable-protocols
    --disable-parsers
    --disable-filters
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

COMMON_MERGE_OPTIONS="
    libavcodec/libavcodec.a
    libavfilter/libavfilter.a
    libavformat/libavformat.a
    libavutil/libavutil.a
    libswresample/libswresample.a
    libswscale/libswscale.a
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker
"

# armeabi-v7a
SYSROOT="${NDK_PATH}/platforms/android-16/arch-arm"
PREFIX="${FFMPEG_LIB_PATH}/armeabi-v7a"

./configure \
    --prefix=$PREFIX \
    --arch=arm \
    --cpu=armv7-a \
    --cross-prefix="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-" \
    --nm="${TOOLCHAIN_PREFIX}/arm-linux-androideabi-nm" \
    --cc="${TOOLCHAIN_PREFIX}/armv7a-linux-androideabi16-clang" \
    --extra-cflags="-march=armv7-a -mfloat-abi=softfp" \
    --extra-ldflags="-Wl,--fix-cortex-a8" \
    --extra-ldexeflags=-pie \
    ${COMMON_OPTIONS}
make -j8
make install
${TOOLCHAIN_PREFIX}/arm-linux-androideabi-ld \
    -rpath-link=$SYSROOT/usr/lib \
    -L$SYSROOT/usr/lib \
    -L$PREFIX/lib \
    -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
    $PREFIX/libffmpeg.so \
    ${COMMON_MERGE_OPTIONS} \
    ${GCC_PREFIX}/arm-linux-androideabi/4.9.x/libgcc_real.a
${TOOLCHAIN_PREFIX}/arm-linux-androideabi-strip  $PREFIX/libffmpeg.so
make clean

# arm64-v8a
SYSROOT="${NDK_PATH}/platforms/android-21/arch-arm64"
PREFIX="${FFMPEG_LIB_PATH}/arm64-v8a"
./configure \
    --prefix=$PREFIX \
    --arch=aarch64 \
    --cpu=armv8-a \
    --cross-prefix="${TOOLCHAIN_PREFIX}/aarch64-linux-android-" \
    --nm="${TOOLCHAIN_PREFIX}/aarch64-linux-android-nm" \
    --cc="${TOOLCHAIN_PREFIX}/aarch64-linux-android21-clang" \
    --extra-ldexeflags=-pie \
    ${COMMON_OPTIONS}
make -j8
make install
${TOOLCHAIN_PREFIX}/aarch64-linux-android-ld \
    -rpath-link=$SYSROOT/usr/lib \
    -L$SYSROOT/usr/lib \
    -L$PREFIX/lib \
    -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
    $PREFIX/libffmpeg.so \
    ${COMMON_MERGE_OPTIONS} \
    ${GCC_PREFIX}/aarch64-linux-android/4.9.x/libgcc_real.a
${TOOLCHAIN_PREFIX}/aarch64-linux-android-strip  $PREFIX/libffmpeg.so
make clean

# x86
SYSROOT="${NDK_PATH}/platforms/android-16/arch-x86"
PREFIX="${FFMPEG_LIB_PATH}/x86"
./configure \
    --prefix=$PREFIX \
    --arch=x86 \
    --cpu=i686 \
    --cross-prefix="${TOOLCHAIN_PREFIX}/i686-linux-android-" \
    --nm="${TOOLCHAIN_PREFIX}/i686-linux-android-nm" \
    --cc="${TOOLCHAIN_PREFIX}/i686-linux-android16-clang" \
    --extra-ldexeflags=-pie \
    --disable-asm \
    ${COMMON_OPTIONS}
make -j8
make install
${TOOLCHAIN_PREFIX}/i686-linux-android-ld \
    -rpath-link=$SYSROOT/usr/lib \
    -L$SYSROOT/usr/lib \
    -L$PREFIX/lib \
    -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
    $PREFIX/libffmpeg.so \
    ${COMMON_MERGE_OPTIONS} \
    ${GCC_PREFIX}/i686-linux-android/4.9.x/libgcc_real.a
${TOOLCHAIN_PREFIX}/i686-linux-android-strip  $PREFIX/libffmpeg.so
make clean

# Copy libffmpeg.so to library/libs
echo "Start copy"
LIBRARY_LIBS_PATH=../library/libs
cp ${FFMPEG_LIB_PATH}/arm64-v8a/libffmpeg.so   ${LIBRARY_LIBS_PATH}/arm64-v8a/libffmpeg.so
cp ${FFMPEG_LIB_PATH}/armeabi-v7a/libffmpeg.so ${LIBRARY_LIBS_PATH}/armeabi-v7a/libffmpeg.so
cp ${FFMPEG_LIB_PATH}/x86/libffmpeg.so         ${LIBRARY_LIBS_PATH}/x86/libffmpeg.so
echo "End copy"