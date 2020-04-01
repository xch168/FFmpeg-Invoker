package com.github.xch168.ffmpeg.invoker.demo;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.os.Looper;
import android.view.View;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.github.xch168.ffmpeg.invoker.FFmpegCmd;
import com.github.xch168.ffmpeg.invoker.FFmpegInvoker;

import java.io.File;

public class FFmpegTestActivity extends AppCompatActivity {
    private ProgressDialog mProgressDialog;

    private String videoPath = "/storage/emulated/0/DCIM/Camera/fb639313f7f3d58cc793f20095439c88.mp4";
    private String videoPath2 = "/storage/emulated/0/4399YouPai/Record/LYL_20200316_155722.mp4";

    private FFmpegInvoker.Callback mCallback = new FFmpegInvoker.Callback() {
        @Override
        public void onSuccess() {
            Looper.prepare();
            hideProgress();
            Toast.makeText(FFmpegTestActivity.this, "处理成功", Toast.LENGTH_SHORT).show();
            Looper.loop();
        }

        @Override
        public void onFailure() {
            Looper.prepare();
            hideProgress();
            Toast.makeText(FFmpegTestActivity.this, "处理失败", Toast.LENGTH_SHORT).show();
            Looper.loop();
        }

        @Override
        public void onProgress(float percent) {
            updateProgress(percent);
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

    private void showProgress() {
        if (mProgressDialog == null) {
            mProgressDialog = new ProgressDialog(this);
            mProgressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
            mProgressDialog.setCanceledOnTouchOutside(false);
            mProgressDialog.setMax(100);
            mProgressDialog.setTitle("正在处理");
        }
        mProgressDialog.setProgress(0);
        mProgressDialog.show();
    }

    private void hideProgress() {
        if (mProgressDialog != null) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mProgressDialog.hide();
                }
            });
        }
    }

    private void updateProgress(float percent) {
        mProgressDialog.setProgress((int) (percent * mProgressDialog.getMax()));
    }

    public void cutVideo(View view) {
        showProgress();
        String savePath = getSaveDir() + "out.mp4";
        FFmpegCmd cmd = new FFmpegCmd();
        cmd.append("-ss").append(1);
        cmd.append("-t").append(500);
        cmd.append("-accurate_seek");
        cmd.append("-i").append(videoPath2);
        cmd.append("-codec").append("copy");
        cmd.append(savePath);

//        String cmd = "ffmpeg -y -ss 1 -t 500 -accurate_seek -i " + videoPath2 + " -codec copy " + savePath;
        FFmpegInvoker.exec(cmd.build(), mCallback);
    }

    public void extractFrame(View view) {
        showProgress();
        String savePath = getSaveDir() + "out.png";
        FFmpegCmd cmd = new FFmpegCmd();
        cmd.append("-ss").append(10);
        cmd.append("-i").append(videoPath);
        cmd.append("-vframes").append(1);
        cmd.append(savePath);
//        String cmd = "ffmpeg -ss 10 -i " + videoPath + " -vframes 1 -y " + savePath;
        FFmpegInvoker.exec(cmd.build(), mCallback);
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
