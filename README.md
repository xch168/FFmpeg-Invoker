# FFmpeg-Invoker
FFmpeg invoker

## Download
```groovy
implementation 'com.github.xch168:ffmpeg-invoker:0.0.1'
```
The Library supports three cpu abi: `armeabi-v7a`, `arm64-v8a`, `x86`.
If you don't need x86 lib, you can exclude it according to the following configuration:
```groovy
android {
    ...
    packagingOptions {
        exclude 'lib/x86/*.so'
    }
}
```

## Usage
```java
// ffmpeg -y -ss 1 -t 100 -accurate_seek -i + videoPath + -codec copy + savePath
// you can use FFmpegCmd to build an ffmpeg command
FFmpegCmd cmd = new FFmpegCmd();
cmd.append("-ss").append(1);
cmd.append("-t").append(500);
cmd.append("-accurate_seek");
cmd.append("-i").append(videoPath2);
cmd.append("-codec").append("copy");
cmd.append(savePath);

FFmpegInvoker.exec(cmd.build(), new FFmpegInvoker.Callback() {
    @Override
    public void onSuccess() {

    }

    @Override
    public void onFailure() {

    }

    @Override
    public void onProgress(float percent) {

    }
});
```

## Build FFmpeg
```shell script
$ git clone git@github.com:xch168/FFmpeg-Invoker.git
$ cd FFmpeg-Invoker
$ ./build_ffmpeg.sh
````

License
-------

    Copyright (c) 2020-present. xch168

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.