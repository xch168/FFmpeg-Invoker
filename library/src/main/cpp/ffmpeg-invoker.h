#include <jni.h>

#ifndef FFmpeg_Invoker
#define FFmpeg_Invoker
#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT jint JNICALL
Java_com_github_xch168_ffmpeg_invoker_FFmpegInvoker_exec(JNIEnv *, jclass, jint, jobjectArray);

JNIEXPORT void JNICALL
Java_com_github_xch168_ffmpeg_invoker_FFmpegInvoker_exit(JNIEnv *, jclass);

JNIEXPORT jstring JNICALL
Java_com_github_xch168_ffmpeg_invoker_FFmpegInvoker_getConfigInfo(JNIEnv *, jclass);

JNIEXPORT jstring JNICALL
Java_com_github_xch168_ffmpeg_invoker_FFmpegInvoker_getAVCodecInfo(JNIEnv *env, jclass clazz);

JNIEXPORT jstring JNICALL
Java_com_github_xch168_ffmpeg_invoker_FFmpegInvoker_getAVFormatInfo(JNIEnv *, jclass);

JNIEXPORT jstring JNICALL
Java_com_github_xch168_ffmpeg_invoker_FFmpegInvoker_getAVFilterInfo(JNIEnv *, jclass);

#ifdef __cplusplus
}
#endif
#endif

void ffmpeg_progress(float progress);