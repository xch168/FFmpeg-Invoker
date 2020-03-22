package com.github.xch168.ffmpeg.invoker.demo;

import android.os.Build;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.github.xch168.ffmpeg.invoker.FFmpegInvoker;

public class MainActivity extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView tv = findViewById(R.id.tv_cpu_abi);
        tv.setText("CPU_ABI: " + getCpuAbi());

        TextView configView = findViewById(R.id.tv_config_info);
        configView.setMovementMethod(ScrollingMovementMethod.getInstance());
        configView.setText(getConfigInfo());
    }

    private String getCpuAbi() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            return Build.CPU_ABI;
        } else {
            return Build.SUPPORTED_ABIS[0];
        }
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

}
