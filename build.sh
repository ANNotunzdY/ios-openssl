#!/bin/sh

# Yay shell scripting! This script builds a static version of
# OpenSSL 1.0.0a for iOS 4.2 that contains code for armv6, armv7 and i386.

set -x

OPENSSL_CONFIGURE_OPTIONS=

rm -rf include lib *.log

rm -rf /tmp/openssl-1.0.0h-*
rm -rf /tmp/openssl-1.0.0h-*.log

# ARMv6

rm -rf openssl-1.0.0h
tar xfz openssl-1.0.0h.tar.gz
pushd .
cd openssl-1.0.0h
./configure BSD-generic32 --openssldir=/tmp/openssl-1.0.0h-armv6 $OPENSSL_CONFIGURE_OPTIONS &> /tmp/openssl-1.0.0h-armv6.log
perl -i -pe 's|static volatile sig_atomic_t intr_signal|static volatile int intr_signal|' crypto/ui/ui_openssl.c
perl -i -pe 's|^CC= gcc|CC= /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc -arch armv6|g' Makefile
perl -i -pe 's|^CFLAG= (.*)|CFLAG= -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk $1|g' Makefile
make &> /tmp/openssl-1.0.0h-armv6.log
make install &> /tmp/openssl-1.0.0h-armv6.log
popd
rm -rf openssl-1.0.0h

# ARMv7

rm -rf openssl-1.0.0h
tar xfz openssl-1.0.0h.tar.gz
pushd .
cd openssl-1.0.0h
./configure BSD-generic32 --openssldir=/tmp/openssl-1.0.0h-armv7 $OPENSSL_CONFIGURE_OPTIONS >> /tmp/openssl-1.0.0h-armv7.log
perl -i -pe 's|static volatile sig_atomic_t intr_signal|static volatile int intr_signal|' crypto/ui/ui_openssl.c
perl -i -pe 's|^CC= gcc|CC= /Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc -arch armv7|g' Makefile
perl -i -pe 's|^CFLAG= (.*)|CFLAG= -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk $1|g' Makefile
make &> /tmp/openssl-1.0.0h-armv7.log
make install &> /tmp/openssl-1.0.0h-armv7.log
popd
rm -rf openssl-1.0.0h

# i386

rm -rf openssl-1.0.0h
tar xfz openssl-1.0.0h.tar.gz
pushd .
cd openssl-1.0.0h
./configure BSD-generic32 --openssldir=/tmp/openssl-1.0.0h-i386 $OPENSSL_CONFIGURE_OPTIONS >> /tmp/openssl-1.0.0h-i386.log
perl -i -pe 's|static volatile sig_atomic_t intr_signal|static volatile int intr_signal|' crypto/ui/ui_openssl.c
perl -i -pe 's|^CC= gcc|CC= /Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/gcc -arch i386|g' Makefile
perl -i -pe 's|^CFLAG= (.*)|CFLAG= -isysroot /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.0.sdk $1|g' Makefile
make &> /tmp/openssl-1.0.0h-i386.log
make install &> /tmp/openssl-1.0.0h-i386.log
popd
rm -rf openssl-1.0.0h

#

mkdir include
cp -r /tmp/openssl-1.0.0h-i386/include/openssl include/

mkdir lib
lipo \
	/tmp/openssl-1.0.0h-armv6/lib/libcrypto.a \
	/tmp/openssl-1.0.0h-armv7/lib/libcrypto.a \
	/tmp/openssl-1.0.0h-i386/lib/libcrypto.a \
	-create -output lib/libcrypto.a
lipo \
	/tmp/openssl-1.0.0h-armv6/lib/libssl.a \
	/tmp/openssl-1.0.0h-armv7/lib/libssl.a \
	/tmp/openssl-1.0.0h-i386/lib/libssl.a \
	-create -output lib/libssl.a

#rm -rf /tmp/openssl-1.0.0h-*
#rm -rf /tmp/openssl-1.0.0h-*.log

