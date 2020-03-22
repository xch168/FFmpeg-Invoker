package com.github.xch168.ffmpeg.invoker;

import android.util.Log;

/**
 * Created by XuCanHui on 2020/3/14.
 */
public class FFmpegInvoker {
    private static final String TAG = "FFmpegInvoker";

    static {
        System.loadLibrary("ffmpeg-invoker");
    }

    private static Callback sCallback;
    private static long sDuration;

    public static native int exec(int argc, String[] argv);
    public static native void exit();

    public static native String getConfigInfo();
    public static native String getAVCodecInfo();
    public static native String getAVFormatInfo();
    public static native String getAVFilterInfo();

    public static void exec(String[] cmds, long duration, Callback listener) {
        sCallback = listener;
        sDuration = duration;

        StringBuilder cmdBuilder = new StringBuilder();
        for (String cmd : cmds)
        {
            cmdBuilder.append(" ").append(cmd);
        }

        Log.i(TAG, "ffmpeg cmd:" + cmdBuilder.toString());

        exec(cmds.length, cmds);
    }

    /**
     * FFmpeg执行结束回调，由C代码中调用
     */
    public static void onExecuted(int ret) {
        if (sCallback != null) {
            if (ret == 0) {
                sCallback.onProgress(sDuration);
                sCallback.onSuccess();
            } else {
                sCallback.onFailure();
            }
        }
    }

    /**
     * FFmpeg执行进度回调，由C代码调用
     */
    public static void onProgress(float progress) {
        if (sCallback != null) {
            if (sDuration != 0) {
                sCallback.onProgress(progress / (sDuration / 1000) * 0.95f);
            }
        }
    }

    public interface Callback {
        void onSuccess();
        void onFailure();
        void onProgress(float progress);
    }
}
