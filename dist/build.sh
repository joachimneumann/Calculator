#!/bin/bash

set -x

CURRENT=`pwd`
__pr="--print-path"
__name="xcode-select"
DEVELOPER=`${__name} ${__pr}`

SDKVERSION=`xcrun -sdk iphoneos --show-sdk-version`

MIN_IOS="14.0"

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

	EXTRAS=""
	if [ "${ARCH}" != "x86_64" ]; then
		EXTRAS="-miphoneos-version-min=${MIN_IOS} -no-integrated-as -arch ${ARCH} -target ${ARCH}-apple-darwin"
	fi

	CFLAGS="${BITCODE} -isysroot ${SDK} -Wno-error -Wno-implicit-function-declaration ${EXTRAS} ${COMPILEARGS}"

	./configure CC="${CLANG} ${CFLAGS}"  CPP="${CLANG} -E"  CPPFLAGS="${CFLAGS}" \
	--host=aarch64-apple-darwin --disable-assembly --enable-static --disable-shared ${CONFIGUREARGS}

	echo "make in progress for ${ARCH}"
	make &> "${CURRENT}/build.log"
}

# code signing: get the correct expanded identity with the command $security find-identity

rm -rf iPhone simulator catalyst
mkdir iPhone simulator catalyst

cd gmp
build "arm64" "${IPHONEOS_SDK}" "${IPHONEOS_PLATFORM}"
cp .libs/libgmp.a ../iPhone/libgmp.a

build "x86_64" "${IPHONESIMULATOR_SDK}" "${IPHONESIMULATOR_PLATFORM}"
cp .libs/libgmp.a ../simulator/libgmp.a

build "x86_64" "${OSX_SDK}" "${OSX_PLATFORM}" "-target x86_64-apple-ios-macabi"
cp .libs/libgmp.a ../catalyst/libgmp.a
# For Apple Silicon, I might need CFLAGS="-arch x86_64 -arch arm64"
cd ..

cd mpfr
build "arm64" "${IPHONEOS_SDK}" "${IPHONEOS_PLATFORM}" "" "--with-gmp-lib=/Users/joachim/projects/Calculator/dist/iPhone --with-gmp-include=/Users/joachim/projects/Calculator/dist/include"
cp src/.libs/libmpfr.a ../iPhone/libmpfr.a

build "x86_64" "${IPHONESIMULATOR_SDK}" "${IPHONESIMULATOR_PLATFORM}" "" "--with-gmp-lib=/Users/joachim/projects/Calculator/dist/simulator --with-gmp-include=/Users/joachim/projects/Calculator/dist/include"
cp src/.libs/libmpfr.a ../simulator/libmpfr.a

build "x86_64" "${OSX_SDK}" "${OSX_PLATFORM}" "-target x86_64-apple-ios-macabi" "--with-gmp-lib=/Users/joachim/projects/Calculator/dist/catalyst --with-gmp-include=/Users/joachim/projects/Calculator/dist/include"
cp src/.libs/libmpfr.a ../catalyst/libmpfr.a
cd ..

cp iPhone/libgmp.a iPhone/libgmp.signed.a
cp simulator/libgmp.a simulator/libgmp.signed.a
cp catalyst/libgmp.a catalyst/libgmp.signed.a

cp iPhone/libmpfr.a iPhone/libmpfr.signed.a
cp simulator/libmpfr.a simulator/libmpfr.signed.a
cp catalyst/libmpfr.a catalyst/libmpfr.signed.a

identity='FACE74BA2EE33369639EFA6A656F43ED078BE112'
codesign -s ${identity} iPhone/libgmp.signed.a
codesign -s ${identity} simulator/libgmp.signed.a
codesign -s ${identity} catalyst/libgmp.signed.a

codesign -s ${identity} iPhone/libmpfr.signed.a
codesign -s ${identity} simulator/libmpfr.signed.a
codesign -s ${identity} catalyst/libmpfr.signed.a

rm -rf xcframework
mkdir xcframework
mkdir xcframework/iPhone
mkdir xcframework/simulator
mkdir xcframework/catalyst

cp iPhone/libgmp.signed.a xcframework/iPhone/libgmp.a
cp simulator/libgmp.signed.a xcframework/simulator/libgmp.a
cp catalyst/libgmp.signed.a xcframework/catalyst/libgmp.a

cp iPhone/libmpfr.signed.a xcframework/iPhone/libmpfr.a
cp simulator/libmpfr.signed.a xcframework/simulator/libmpfr.a
cp catalyst/libmpfr.signed.a xcframework/catalyst/libmpfr.a

rm -rf mpfr.xcframework gmp.xcframework
xcodebuild -create-xcframework -library xcframework/iPhone/libgmp.a  -library xcframework/simulator/libgmp.a  -library xcframework/catalyst/libgmp.a  -output gmp.xcframework
xcodebuild -create-xcframework -library xcframework/iPhone/libmpfr.a -library xcframework/simulator/libmpfr.a -library xcframework/catalyst/libmpfr.a -output mpfr.xcframework
