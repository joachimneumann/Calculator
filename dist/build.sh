#!/bin/bash

set -x

CURRENT=`pwd`
__pr="--print-path"
__name="xcode-select"
DEVELOPER=`${__name} ${__pr}`

BITCODE="-fembed-bitcode"


PLATFORM_IPHONE=`xcrun --sdk iphoneos --show-sdk-platform-path`
PLATFORM_SIMULATOR=`xcrun --sdk iphonesimulator --show-sdk-platform-path`
PLATFORM_OSX=`xcrun --sdk macosx --show-sdk-platform-path`

SDK_IPHONE=`xcrun --sdk iphoneos --show-sdk-path`
SDK_SIMULATOR=`xcrun --sdk iphonesimulator --show-sdk-path`
SDK_OSX=`xcrun --sdk macosx --show-sdk-path`

CLANG=`xcrun --sdk iphoneos --find clang`
CLANGPP=`xcrun --sdk iphoneos --find clang++`

TARGET_IPHONE="arm64-apple-ios15.0"
TARGET_SIMULATOR=${TARGET_IPHONE}"-simulator"
TARGET_IPHONE_MAC="x86_64-apple-darwin22.1.0" # MACOS 13.0 ventura

build()
{
	ARCH=$1
	SDK=$2
	PLATFORM=$3
	COMPILEARGS=$4
	CONFIGUREARGS=$5

	make clean
	make distclean

	export PATH="${PLATFORM}/Developer/usr/bin:${DEVELOPER}/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

	CFLAGS="${BITCODE} -isysroot ${SDK} -Wno-error -Wno-implicit-function-declaration -arch ${ARCH} ${COMPILEARGS}"

	./configure CC="${CLANG} ${CFLAGS}"  CPP="${CLANG} -E"  CPPFLAGS="${CFLAGS}" \
	--host=aarch64-apple-darwin --disable-assembly --enable-static --disable-shared ${CONFIGUREARGS}

	echo "make in progress for ${ARCH}"
	make &> "${CURRENT}/build.log"
}

rm -rf ${TARGET_IPHONE} ${TARGET_SIMULATOR}
mkdir ${TARGET_IPHONE} ${TARGET_SIMULATOR}

cd gmp
build "arm64" "${SDK_IPHONE}" "${PLATFORM_IPHONE}" "-target ${TARGET_IPHONE}"
cp .libs/libgmp.a ../${TARGET_IPHONE}/libgmp.a

build "arm64" "${SDK_SIMULATOR}" "${PLATFORM_SIMULATOR}" "-target ${TARGET_SIMULATOR}"
cp .libs/libgmp.a ../${TARGET_SIMULATOR}/libgmp.a
cd ..

pwd=`pwd`

cd mpfr
build "arm64" "${SDK_IPHONE}" "${PLATFORM_IPHONE}" "-target ${TARGET_IPHONE}" "--with-gmp-lib=../${TARGET_IPHONE} --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../${TARGET_IPHONE}/libmpfr.a

build "arm64" "${SDK_SIMULATOR}" "${PLATFORM_SIMULATOR}" "-target ${TARGET_SIMULATOR}" "--with-gmp-lib=../${TARGET_SIMULATOR} --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../${TARGET_SIMULATOR}/libmpfr.a

cd ..

rm -rf signed
mkdir signed
cp -r ${TARGET_IPHONE} ${TARGET_SIMULATOR} signed

# code signing: get the correct expanded identity with the command $security find-identity
identity='07CE931939C2E7BA7E99210B7DE7BC6A85CEE016'
codesign -s ${identity} signed/${TARGET_IPHONE}/libgmp.a
codesign -s ${identity} signed/${TARGET_SIMULATOR}/libgmp.a
codesign -s ${identity} signed/${TARGET_IPHONE}/libmpfr.a
codesign -s ${identity} signed/${TARGET_SIMULATOR}/libmpfr.a

rm -rf mpfr.xcframework gmp.xcframework
xcodebuild -create-xcframework -library signed/${TARGET_IPHONE}/libgmp.a  -library signed/${TARGET_SIMULATOR}/libgmp.a  -output gmp.xcframework
xcodebuild -create-xcframework -library signed/${TARGET_IPHONE}/libmpfr.a -library signed/${TARGET_SIMULATOR}/libmpfr.a -output mpfr.xcframework
