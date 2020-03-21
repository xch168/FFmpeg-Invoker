cmake_minimum_required(VERSION 3.4.1)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")

# 添加头文件路径
include_directories(
        src/main/cpp
        src/main/cpp/include
        src/main/cpp/ffmpeg
)

# 定义源码所在目录
aux_source_directory(src/main/cpp SRC)
aux_source_directory(src/main/cpp/ffmpeg SRC_FFMPEG)

# 将 SRC_FFMPEG 添加到 SRC 中
list(APPEND SRC ${SRC_FFMPEG})

# 设置ffmpeg库所在路径的目录
set(distribution_DIR ${CMAKE_SOURCE_DIR}/libs/${ANDROID_ABI})

# 编译一个ffmpeg-invoker库
add_library( ffmpeg-invoker # 库名称
        SHARED         # 库类型
        ${SRC})        # 编译进库的源码)

# 添加libavcodec.so库
add_library( avcodec
        SHARED
        IMPORTED )
# 指定libavcodec.so库的位置
set_target_properties( avcodec
        PROPERTIES IMPORTED_LOCATION
        ${distribution_DIR}/libavcodec.so )

# libavfilter.so库
add_library( avfilter
        SHARED
        IMPORTED )
# libavfilter.so库的位置
set_target_properties( avfilter
        PROPERTIES IMPORTED_LOCATION
        ${distribution_DIR}/libavfilter.so )

# 添加libavformat.so库
add_library( avformat
        SHARED
        IMPORTED )
# 指定libavformat.so库的位置
set_target_properties( avformat
        PROPERTIES IMPORTED_LOCATION
        ${distribution_DIR}/libavformat.so )

# 添加libavresample.so库
add_library( avresample
        SHARED
        IMPORTED )
# 指定libavresample.so库的位置
set_target_properties( avresample
        PROPERTIES IMPORTED_LOCATION
        ${distribution_DIR}/libavresample.so )

# libavutil.so库
add_library( avutil
        SHARED
        IMPORTED )
# 指定libavutil.so库的位置
set_target_properties( avutil
        PROPERTIES IMPORTED_LOCATION
        ${distribution_DIR}/libavutil.so )

# libswresample.so库
add_library( swresample
        SHARED
        IMPORTED )
# 指定libswresample.so库的位置
set_target_properties( swresample
        PROPERTIES IMPORTED_LOCATION
        ${distribution_DIR}/libswresample.so )

# libswscale.so库
add_library( swscale
        SHARED
        IMPORTED )
# 指定libswscale.so库的位置
set_target_properties( swscale
        PROPERTIES IMPORTED_LOCATION
        ${distribution_DIR}/libswscale.so )

find_library( log-lib
        log )


target_link_libraries( ffmpeg-invoker
        avcodec
        avfilter
        avformat
        avresample
        swresample
        swscale
        avutil
        -landroid     # native_window
        -ljnigraphics # bitmap
        -lOpenSLES    # openSLES
        ${log-lib} )