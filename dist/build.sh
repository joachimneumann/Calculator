#!/bin/bash

set -x

CURRENT=`pwd`
__pr="--print-path"
__name="xcode-select"
DEVELOPER=`${__name} ${__pr}`

BITCODE="-fembed-bitcode"

OSX_PLATFORM=`xcrun --sdk macosx --show-sdk-platform-path`
OSX_SDK=`xcrun --sdk macosx --show-sdk-path`

IPHONEOS_PLATFORM=`xcrun --sdk iphoneos --show-sdk-platform-path`
IPHONEOS_SDK=`xcrun --sdk iphoneos --show-sdk-path`

IPHONESIMULATOR_PLATFORM=`xcrun --sdk iphonesimulator --show-sdk-platform-path`
IPHONESIMULATOR_SDK=`xcrun --sdk iphonesimulator --show-sdk-path`

CLANG=`xcrun --sdk iphoneos --find clang`
CLANGPP=`xcrun --sdk iphoneos --find clang++`


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

# rm -rf arm64-apple-ios15.0 arm64-apple-ios15.0-simulator
# mkdir arm64-apple-ios15.0 arm64-apple-ios15.0-simulator
#
# cd gmp
# build "arm64" "${IPHONEOS_SDK}" "${IPHONEOS_PLATFORM}" "-target arm64-apple-ios15.0"
# cp .libs/libgmp.a ../arm64-apple-ios15.0/libgmp.a
#
# build "arm64" "${IPHONESIMULATOR_SDK}" "${IPHONESIMULATOR_PLATFORM}" "-target arm64-apple-ios15.0-simulator"
# cp .libs/libgmp.a ../arm64-apple-ios15.0-simulator/libgmp.a
# cd ..
#
# pwd=`pwd`

cd mpfr
build "arm64" "${IPHONEOS_SDK}" "${IPHONEOS_PLATFORM}" "-target arm64-apple-ios15.0" "--with-gmp-lib=../arm64-apple-ios15.0 --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../arm64-apple-ios15.0/libmpfr.a

build "arm64" "${IPHONESIMULATOR_SDK}" "${IPHONESIMULATOR_PLATFORM}" "-target arm64-apple-ios15.0-simulator" "--with-gmp-lib=../arm64-apple-ios15.0-simulator --with-gmp-include=../include"
cp src/.libs/libmpfr.a ../arm64-apple-ios15.0-simulator/libmpfr.a

cd ..

rm -rf signed
mkdir signed
cp -r arm64-apple-ios15.0 arm64-apple-ios15.0-simulator signed

# code signing: get the correct expanded identity with the command $security find-identity
identity='07CE931939C2E7BA7E99210B7DE7BC6A85CEE016'
codesign -s ${identity} signed/arm64-apple-ios15.0/libgmp.a
codesign -s ${identity} signed/arm64-apple-ios15.0-simulator/libgmp.a
codesign -s ${identity} signed/arm64-apple-ios15.0/libmpfr.a
codesign -s ${identity} signed/arm64-apple-ios15.0-simulator/libmpfr.a

rm -rf mpfr.xcframework gmp.xcframework
xcodebuild -create-xcframework -library signed/arm64-apple-ios15.0/libgmp.a  -library signed/arm64-apple-ios15.0-simulator/libgmp.a  -output gmp.xcframework
xcodebuild -create-xcframework -library signed/arm64-apple-ios15.0/libmpfr.a -library signed/arm64-apple-ios15.0-simulator/libmpfr.a -output mpfr.xcframework

# cp -r gmp.xcframework/ios-x86_64-maccatalyst gmp.xcframework/ios-arm64_x86_64-maccatalyst
# cp -r mpfr.xcframework/ios-x86_64-maccatalyst mpfr.xcframework/ios-arm64_x86_64-maccatalyst

# Troubleshooting:
# remove frameworks from copy in build phases
# Exclusive Access to memory: compile time only
