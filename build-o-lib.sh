#!/bin/sh

# directories
CURRENT_FOLDER=`pwd`
LIBS_FOLDER="$CURRENT_FOLDER/libs"
TARGET_O_FOLDER="$CURRENT_FOLDER/target-o"
TMP_MERGE_FOLDER="$CURRENT_FOLDER/tmp-merge"
TARGET_MERGE_FOLDER="$CURRENT_FOLDER/target-merge"
ARCHS="arm64 armv7 i386 x86_64"
LIBS="FFmpeg libsmbclient libtalloc libtdb libtevent libwbclient"
FRAMEWORK_NAME="FFmpeg"

function LipoDotA() {
  for LIB in $LIBS; do
    for ARCH in $ARCHS; do
    folder="$TARGET_O_FOLDER/$LIB/$ARCH"
    mkdir -p $folder
    lib_path="$LIBS_FOLDER/$LIB.a"
    target_lib_path="$folder/$LIB-$ARCH.a"
    # echo "yelllowei-log: folder>>>>>> $folder"
    # echo "yelllowei-log: LIBS_FOLDER>>>>>> $LIBS_FOLDER"
    # echo "yelllowei-log: lib_path>>>>>> $lib_path"
    # echo "yelllowei-log: target_lib_path>>>>>> $target_lib_path"
    echo "yelllowei-log: lipo dot a for $target_lib_path"
    lipo $lib_path -thin $ARCH -o $target_lib_path
    done
  done
  echo "yelllowei-log: create dot o compeleted"
}


function CreateDotO() {
  root_path="$CURRENT_FOLDER"
  for LIB in $LIBS; do
  	for ARCH in $ARCHS; do
    	folder="$TARGET_O_FOLDER/$LIB/$ARCH/O"
    	mkdir -p $folder
    	cd $folder
    	echo "yelllowei-log: create dot o for $LIB-$ARCH.a"
    	ar x "../$LIB-$ARCH.a"
    	cd $root_path
    done
  done
  echo "yelllowei-log: create dot o compeleted"
}

function UseCmd_ar_MergeDotO() {
  root_path="$CURRENT_FOLDER"
  local files=""
  for LIB in $LIBS; do
  	for ARCH in $ARCHS; do
    	dot_o_folder="$TARGET_O_FOLDER/$LIB/$ARCH/O/*"
    	merge_folder="$TMP_MERGE_FOLDER/merge-$ARCH"
    	mkdir -p $merge_folder
    	echo "yelllowei-log: cp -p $dot_o_folder $merge_folder"
    	cp -p $dot_o_folder $merge_folder
    done
  done
  echo "yelllowei-log: cp -p compeleted"
  echo "yelllowei-log: start merge to dot a"
  target_folder="$TARGET_MERGE_FOLDER"
  mkdir -p $target_folder
  cd $target_folder
  for ARCH in $ARCHS; do
    merge_folder="$TMP_MERGE_FOLDER/merge-$ARCH"
    name="$FRAMEWORK_NAME-$ARCH.a"
    ar cru $name $(find $merge_folder -name "*.o")
    files="$files $name"
  done
  lipo -create $files -output FFmpeg
}



# CompileSource
LipoDotA
CreateDotO
UseCmd_ar_MergeDotO
