#!/bin/bash

FFMPEG_PATH=./ffmpeg

cp ${FFMPEG_PATH}/android-libs/arm64-v8a/libffmpeg.so   ./library/libs/arm64-v8a/libffmpeg.so
cp ${FFMPEG_PATH}/android-libs/armeabi-v7a/libffmpeg.so ./library/libs/armeabi-v7a/libffmpeg.so
cp ${FFMPEG_PATH}/android-libs/x86/libffmpeg.so         ./library/libs/x86/libffmpeg.so