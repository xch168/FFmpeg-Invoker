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

#ifdef __cplusplus
}
#endif
#endif

void ffmpeg_progress(float progress);
