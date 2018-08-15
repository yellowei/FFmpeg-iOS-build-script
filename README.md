# FFmpeg iOS build script

[![Build Status](https://travis-ci.org/kewlbear/FFmpeg-iOS-build-script.svg?branch=master)](https://travis-ci.org/kewlbear/FFmpeg-iOS-build-script)

This is a shell script to build FFmpeg libraries for iOS and tvOS apps.

Tested with:

* FFmpeg 3.4
* Xcode 9

## Requirements

* https://github.com/libav/gas-preprocessor
* yasm 1.2.0

## Usage

Use build-ffmpeg-tvos.sh for tvOS.

* To build everything:

        ./build-ffmpeg.sh

* To build arm64 libraries:

        ./build-ffmpeg.sh arm64

* To build fat libraries for armv7 and x86_64 (64-bit simulator):

        ./build-ffmpeg.sh armv7 x86_64

* To build fat libraries from separately built thin libraries:

        ./build-ffmpeg.sh lipo

## Download

You can download a binary for FFmpeg 3.4 release at https://downloads.sourceforge.net/project/ffmpeg-ios/ffmpeg-ios-master.tar.bz2

## External libraries

You should link your app with

* libz.dylib
* libbz2.dylib
* libiconv.dylib

## Influences

* https://github.com/bbcallen/ijkplayer/blob/fc70895c64cbbd20f32f1d81d2d48609ed13f597/ios/tools/do-compile-ffmpeg.sh#L7

## Build Samba Support

FFmpeg 编入Samba

1.首先kxsmb或者samba-iOS 编译4.0.26的ios库

2.编译好的smb库放入usr/local/Cellar下, smb库放入之前手动分为include和lib两个子文件夹

3.ln -s 刚才已经放入Cellar文件夹下的include和lib所有文件到usr/local/include和usr/local/lib下

4.没有pkg-config的同学, 先安装此神器, 按照图片目录创建
￼
.pc配置文件,
￼
```
prefix=/usr/local/Cellar/smbclient
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: smbclient
Description: Samba library
Version: 4.0.26
Libs: -L${exec_prefix}/lib -lsmbclient -ltalloc -ltdb -ltevent -lwbclient -liconv -lz -lresolv -framework Foundation
Libs.private: -lpthread -lm -ldl
Cflags: -I${prefix}/include
```

5.pkg-config —cflags smbclient 搜索得到就正确了, 接下来就去ffmpeg里面的.sh的”CONFIGURE_FLAGS”内加入
--enable-gpl --enable-version3 --enable-libsmbclient"

6.开始跑脚本


