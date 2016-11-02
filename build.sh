#!/bin/sh

set -x

# Where is the SDK installed
APPD_SDK=/home/stevew/AppDynamics/appdynamics-sdk-native/sdk_lib

# clean
rm *.o *.so *wrap.c *.pm > /dev/null 2>&1

RUBY_INC1="/usr/include/ruby-2.3.0"
RUBY_INC2="/usr/include/x86_64-linux-gnu/ruby-2.3.0"
CFLAGS="-fPIC -I $APPD_SDK -I $RUBY_INC1 -I $RUBY_INC2"

# swig generates the wrapper code
swig -ruby appd.i

echo "CFLAGS"
echo "$CFLAGS"
gcc $CFLAGS -c proxy.c appd_wrap.c

echo "Linking..."
ld -G -L $APPD_SDK/lib proxy.o appd_wrap.o -o appd.so -lappdynamics_native_sdk

