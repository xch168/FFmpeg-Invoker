package com.github.xch168.ffmpeg.invoker.demo;

import android.os.Build;
import android.os.Bundle;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView tv = findViewById(R.id.tv_cpu_abi);
        tv.setText("CPU_ABI: " + getCpuAbi());
    }

    private String getCpuAbi() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            return Build.CPU_ABI;
        } else {
            return Build.SUPPORTED_ABIS[0];
        }
    }

}
