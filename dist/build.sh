#!/bin/bash

if [ ! -d "gmp" ]
then
    echo "download the gmp code from https://gmplib.org/, unpack it and rename the folder to gmp"
    exit 0
fi

if [ ! -d "mpfr" ]
then
    echo "download the mpfr code from https://www.mpfr.org/, unpack it and rename the folder to mpfr"
    exit 0
fi

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
TARGET_IPHONE="ios15.0-arm64"
TARGET_SIMULATOR="arm64-apple-ios15.0-simulator"
TARGET_MAC="macos12.0-arm64"
TARGET_MACX="macos12.0-x86-64"

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

rm -rf ${TARGET_IPHONE} ${TARGET_SIMULATOR} ${TARGET_MAC} ${TARGET_MACX}
mkdir  ${TARGET_IPHONE} ${TARGET_SIMULATOR} ${TARGET_MAC} ${TARGET_MACX}

cd gmp
build "arm64" "${SDK_MAC}" "${PLATFORM_MAC}" "-target ${TARGET_MAC}"
cp .libs/libgmp.a ../${TARGET_MAC}/libgmp.a

build "x86_64" "${SDK_MAC}" "${PLATFORM_MAC}" "-target ${TARGET_MACX}"
cp .libs/libgmp.a ../${TARGET_MACX}/libgmp.a

build "arm64" "${SDK_IPHONE}" "${PLATFORM_IPHONE}" "-target ${TARGET_IPHONE}"
cp .libs/libgmp.a ../${TARGET_IPHONE}/libgmp.a

build "arm64" "${SDK_SIMULATOR}" "${PLATFORM_SIMULATOR}" "-target ${TARGET_SIMULATOR}"
cp .libs/libgmp.a ../${TARGET_SIMULATOR}/libgmp.a
cd ..

cd mpfr
build "arm64" "${SDK_MAC}" "${PLATFORM_MAC}" "-target ${TARGET_MAC}" "--with-gmp-lib=../${TARGET_MAC} --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../${TARGET_MAC}/libmpfr.a

build "x86_64" "${SDK_MAC}" "${PLATFORM_MAC}" "-target ${TARGET_MACX}" "--with-gmp-lib=../${TARGET_MACX} --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../${TARGET_MACX}/libmpfr.a

build "arm64" "${SDK_IPHONE}" "${PLATFORM_IPHONE}" "-target ${TARGET_IPHONE}" "--with-gmp-lib=../${TARGET_IPHONE} --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../${TARGET_IPHONE}/libmpfr.a

build "arm64" "${SDK_SIMULATOR}" "${PLATFORM_SIMULATOR}" "-target ${TARGET_SIMULATOR}" "--with-gmp-lib=../${TARGET_SIMULATOR} --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../${TARGET_SIMULATOR}/libmpfr.a
cd ..

rm -rf signed
mkdir signed
cp -r ${TARGET_IPHONE} ${TARGET_SIMULATOR} ${TARGET_MAC} ${TARGET_MACX} signed

# code signing: to get the correct expanded identity with the command:
# security find-identity
identity='07CE931939C2E7BA7E99210B7DE7BC6A85CEE016'
codesign -s ${identity} signed/${TARGET_IPHONE}/libgmp.a
codesign -s ${identity} signed/${TARGET_IPHONE}/libmpfr.a
codesign -s ${identity} signed/${TARGET_SIMULATOR}/libgmp.a
codesign -s ${identity} signed/${TARGET_SIMULATOR}/libmpfr.a
codesign -s ${identity} signed/${TARGET_MAC}/libgmp.a
codesign -s ${identity} signed/${TARGET_MAC}/libmpfr.a
codesign -s ${identity} signed/${TARGET_MACX}/libgmp.a
codesign -s ${identity} signed/${TARGET_MACX}/libmpfr.a

rm -rf mpfr.xcframework
rm -rf gmp.xcframework
# When I use xcodebuild to create a xcframework, I get this error:
# Both 'macos-x86_64' and 'macos-arm64' represent two equivalent library definitions.
# solution: combine the MAcOS arm and X86 archives with lipo onto one archive
lipo signed/${TARGET_MAC}/libgmp.a  signed/${TARGET_MACX}/libgmp.a  -create -output libgmp.a
lipo signed/${TARGET_MAC}/libmpfr.a signed/${TARGET_MACX}/libmpfr.a -create -output libmpfr.a
xcodebuild -create-xcframework -library signed/${TARGET_IPHONE}/libgmp.a  -library signed/${TARGET_SIMULATOR}/libgmp.a  -library libgmp.a  -output gmp.xcframework
xcodebuild -create-xcframework -library signed/${TARGET_IPHONE}/libmpfr.a -library signed/${TARGET_SIMULATOR}/libmpfr.a -library libmpfr.a -output mpfr.xcframework

# check if the MacOS binary is universal (Intel and M1) with
# lipo -archs ~/Library/Developer/Xcode/DerivedData/Calculator-famakvwslclcbzbpvjeqqkftywmo/Build/Products/Debug/CalculatorMac.app/Contents/MacOS/CalculatorMac
