#include <jni.h>
#include <string>

extern "C"
JNIEXPORT jstring JNICALL
Java_com_github_xch168_ffmpeg_invoker_FFmpegInvoker_stringFromJNI(JNIEnv *env, jclass clazz) {
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}