#!/system/bin/sh

# Magisk Module: OpenSSL-NDK v1.1.1l, supporting APatch and KSU
# Copyright (c) zgfg @ xda, 2024-
# Module installs static NDK OpenSSL v1.1.1l binary, supporting ARMv7 and higher.
# Credits to robertying @ github for pre-built libraries at https://github.com/robertying/openssl-curl-android/releases/tag/1.1.1l-7.78.0
# Test from Terminal Emulator:
# $ su -c which openssl
# $ su -c openssl help

# Module's own path (local path)
MODDIR=${0%/*}

# Log file for debugging
LogFile="$MODDIR/post-fs-data.log"
exec 3>&1 4>&2 2>$LogFile 1>&2
set -x

# Log info
whoami
magisk -c
echo $APATCH
getprop ro.product.cpu.abi
getprop ro.product.cpu.abilist

# Clean-up old stuff
rm -rf "$MODDIR/system"

# Choose XBIN or BIN path
SDIR=/system/xbin
if [ ! -d $SDIR ]
then
  SDIR=/system/bin
fi
SSLDIR=$MODDIR$SDIR

cd $MODDIR
pwd
mkdir -p $SSLDIR
cd $SSLDIR
pwd

SSL=openssl
SSLBin=$MODDIR/$SSL

# Create symlink for OpenSSL binary
if [ -x $SSLBin ] && [ ! -x $SDIR/$SSL ]
then
  # Create symlink
  ln -s $SSLBin $SSL
fi

chmod 755 *
chcon u:object_r:system_file:s0 *

# Log results for OpenSSL binary
ls -lZ $SSL
Version=$(./$SSL version)

set +x
exec 1>&3 2>&4 3>&- 4>&-
