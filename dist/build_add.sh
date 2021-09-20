clang -target x86_64-apple-ios-macabi -arch x86_64 -isysroot `xcrun --sdk macosx --show-sdk-path` -miphoneos-version-min=13.0 -fembed-bitcode -c add.c
ar rc add.catalyist.a add.o

clang -arch arm64 -isysroot `xcrun --sdk iphoneos --show-sdk-path` -miphoneos-version-min=13.0 -fembed-bitcode -c add.c
ar rc add.iPhone.a add.o

clang -arch x86_64 -isysroot `xcrun --sdk iphonesimulator --show-sdk-path` -miphoneos-version-min=13.0 -fembed-bitcode -c add.c
ar rc add.simulator.a add.o

xcodebuild -create-xcframework -library add.simulator.a -library add.iPhone.a -library add.catalyist.a -output add.xcframework
