package com.github.xch168.ffmpeg.invoker;

/**
 * Created by XuCanHui on 2020/4/1.
 */
public class FFmpegCmd {
    private StringBuilder sb;

    public FFmpegCmd() {
        sb = new StringBuilder();
        sb.append("ffmpeg");
        append("-y");
    }

    public FFmpegCmd append(String param) {
        sb.append(" ").append(param);
        return this;
    }

    public FFmpegCmd append(long param) {
        sb.append(" ").append(param);
        return this;
    }

    public FFmpegCmd append(float param) {
        sb.append(" ").append(param);
        return this;
    }

    public String build() {
        return sb.toString();
    }

}
