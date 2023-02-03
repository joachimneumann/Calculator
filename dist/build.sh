#!/bin/bash

set -x

CURRENT=`pwd`
BITCODE="-fembed-bitcode"

PLATFORM_IPHONE=`xcrun --sdk iphoneos --show-sdk-platform-path`
PLATFORM_SIMULATOR=`xcrun --sdk iphonesimulator --show-sdk-platform-path`
PLATFORM_MAC=`xcrun --sdk macosx --show-sdk-platform-path`

SDK_IPHONE=`xcrun --sdk iphoneos --show-sdk-path`
SDK_SIMULATOR=`xcrun --sdk iphonesimulator --show-sdk-path`
SDK_MAC=`xcrun --sdk macosx --show-sdk-path`

CLANG=`xcrun --sdk iphoneos --find clang`
CLANGPP=`xcrun --sdk iphoneos --find clang++`

# TARGET_IPHONE="arm64-apple-ios15.0"
TARGET_IPHONE="ios-arm64"
TARGET_SIMULATOR="arm64-apple-ios15.0-simulator"
TARGET_MAC="macos-arm64"

build()
{
	ARCH=$1
	SDK=$2
	PLATFORM=$3
	COMPILEARGS=$4
	CONFIGUREARGS=$5

	make clean
	make distclean

	export PATH="${PLATFORM}/Developer/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

	CFLAGS="${BITCODE} -isysroot ${SDK} -Wno-error -Wno-implicit-function-declaration -arch ${ARCH} ${COMPILEARGS}"

	./configure CC="${CLANG} ${CFLAGS}"  CPP="${CLANG} -E"  CPPFLAGS="${CFLAGS}" \
	--host=aarch64-apple-darwin --disable-assembly --enable-static --disable-shared ${CONFIGUREARGS}

	echo "make in progress for ${ARCH}"
	make &> "${CURRENT}/build.log"
}

rm -rf ${TARGET_IPHONE} ${TARGET_SIMULATOR} ${TARGET_MAC}
mkdir ${TARGET_IPHONE} ${TARGET_SIMULATOR} ${TARGET_MAC}

cd gmp
build "arm64" "${SDK_MAC}" "${PLATFORM_MAC}" "-target ${TARGET_MAC}"
cp .libs/libgmp.a ../${TARGET_MAC}/libgmp.a

build "arm64" "${SDK_IPHONE}" "${PLATFORM_IPHONE}" "-target ${TARGET_IPHONE}"
cp .libs/libgmp.a ../${TARGET_IPHONE}/libgmp.a

build "arm64" "${SDK_SIMULATOR}" "${PLATFORM_SIMULATOR}" "-target ${TARGET_SIMULATOR}"
cp .libs/libgmp.a ../${TARGET_SIMULATOR}/libgmp.a
cd ..

cd mpfr
build "arm64" "${SDK_MAC}" "${PLATFORM_MAC}" "-target ${TARGET_MAC}" "--with-gmp-lib=../${TARGET_MAC} --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../${TARGET_MAC}/libmpfr.a

build "arm64" "${SDK_IPHONE}" "${PLATFORM_IPHONE}" "-target ${TARGET_IPHONE}" "--with-gmp-lib=../${TARGET_IPHONE} --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../${TARGET_IPHONE}/libmpfr.a

build "arm64" "${SDK_SIMULATOR}" "${PLATFORM_SIMULATOR}" "-target ${TARGET_SIMULATOR}" "--with-gmp-lib=../${TARGET_SIMULATOR} --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../${TARGET_SIMULATOR}/libmpfr.a
cd ..

rm -rf signed
mkdir signed
cp -r ${TARGET_IPHONE} ${TARGET_SIMULATOR} ${TARGET_MAC} signed

# code signing: get the correct expanded identity with the command $security find-identity
identity='07CE931939C2E7BA7E99210B7DE7BC6A85CEE016'
codesign -s ${identity} signed/${TARGET_IPHONE}/libgmp.a
codesign -s ${identity} signed/${TARGET_IPHONE}/libmpfr.a
codesign -s ${identity} signed/${TARGET_SIMULATOR}/libgmp.a
codesign -s ${identity} signed/${TARGET_SIMULATOR}/libmpfr.a
codesign -s ${identity} signed/${TARGET_MAC}/libgmp.a
codesign -s ${identity} signed/${TARGET_MAC}/libmpfr.a

# rm -rf mpfr.xcframework
rm -rf gmp.xcframework
xcodebuild -create-xcframework -library signed/${TARGET_IPHONE}/libgmp.a  -library signed/${TARGET_SIMULATOR}/libgmp.a  -library signed/${TARGET_MAC}/libgmp.a  -output gmp.xcframework
xcodebuild -create-xcframework -library signed/${TARGET_IPHONE}/libmpfr.a -library signed/${TARGET_SIMULATOR}/libmpfr.a -library signed/${TARGET_MAC}/libmpfr.a -output mpfr.xcframework
