package com.github.xch168.ffmpeg.invoker.demo;

import android.os.Build;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.github.xch168.ffmpeg.invoker.FFmpegInvoker;

public class MainActivity extends AppCompatActivity {

    private TextView mConfigView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView tv = findViewById(R.id.tv_cpu_abi);
        tv.setText("CPU_ABI: " + getCpuAbi());

        mConfigView = findViewById(R.id.tv_config_info);
        mConfigView.setMovementMethod(ScrollingMovementMethod.getInstance());

    }

    private String getCpuAbi() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            return Build.CPU_ABI;
        } else {
            return Build.SUPPORTED_ABIS[0];
        }
    }

    public void getFFmpegConfigInfo(View view) {
        mConfigView.setText(getConfigInfo());
    }

    public void getFFmpegCodecInfo(View view) {
        mConfigView.setText(FFmpegInvoker.getAVCodecInfo());
    }

    public void getFFmpegFormatInfo(View view) {
        mConfigView.setText(FFmpegInvoker.getAVFormatInfo());
    }

    public void getFFmpegFilterInfo(View view) {
        mConfigView.setText(FFmpegInvoker.getAVFilterInfo());
    }

    private String getConfigInfo() {
        String configInfo = FFmpegInvoker.getConfigInfo();
        String[] configItems = configInfo.split(" ");
        StringBuilder configInfoBuilder = new StringBuilder();
        for (String config : configItems) {
            configInfoBuilder.append(config).append('\n');
        }
        return configInfoBuilder.toString();
    }

    public void toTestFFmpeg(View view) {
        FFmpegTestActivity.open(this);
    }
}
