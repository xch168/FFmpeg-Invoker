package com.github.xch168.ffmpeg.invoker;

/**
 * Created by XuCanHui on 2020/3/14.
 */
public class FFmpegInvoker {

    static {
        System.loadLibrary("ffmpeg-invoker");
    }

    public static native String stringFromJNI();

    public static void exec(Callback callback)
    {

    }

    public interface Callback {
        void onSuccess();
        void onFailure();
        void onProgress();
    }
}
