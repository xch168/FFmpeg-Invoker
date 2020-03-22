package com.github.xch168.ffmpeg.invoker.demo;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.os.Looper;
import android.view.View;
import android.widget.Toast;

import com.github.xch168.ffmpeg.invoker.FFmpegInvoker;

import java.io.File;

public class FFmpegTestActivity extends AppCompatActivity {
    private String videoPath = "/storage/emulated/0/DCIM/Camera/fb639313f7f3d58cc793f20095439c88.mp4";

    private FFmpegInvoker.Callback mCallback = new FFmpegInvoker.Callback() {
        @Override
        public void onSuccess() {
            Looper.prepare();
            Toast.makeText(FFmpegTestActivity.this, "处理成功", Toast.LENGTH_SHORT).show();
            Looper.loop();
        }

        @Override
        public void onFailure() {
            Looper.prepare();
            Toast.makeText(FFmpegTestActivity.this, "处理失败", Toast.LENGTH_SHORT).show();
            Looper.loop();
        }

        @Override
        public void onProgress(float progress) {

        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ffmpeg_test);
    }

    public static void open(Context context) {
        Intent intent = new Intent(context, FFmpegTestActivity.class);
        context.startActivity(intent);
    }

    public void cutVideo(View view) {
        String savePath = getSaveDir() + "out.mp4";
        String cmd = "ffmpeg -y -ss 1 -t 100 -accurate_seek -i " + videoPath + " -codec copy " + savePath;
        FFmpegInvoker.exec(cmd.split(" "), 100, mCallback);
    }

    public void extractFrame(View view) {
        String savePath = getSaveDir() + "out.png";
        String cmd = "ffmpeg -ss 10 -i " + videoPath + " -vframes 1 -y " + savePath;
        FFmpegInvoker.exec(cmd.split(" "), 100, mCallback);
    }

    public static String getSaveDir() {
        String savePath = Environment.getExternalStorageDirectory().getPath() + "/FFmpegInvoker/";
        File file = new File(savePath);
        if (!file.exists()) {
            file.mkdirs();
        }
        return savePath;
    }
}
