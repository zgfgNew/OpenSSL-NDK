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
LogFile="$MODDIR/service.log"
exec 3>&1 4>&2 2>$LogFile 1>&2
set -x

if [ -z $MODDIR ]
then
  MODDIR=$(pwd)
fi

# Log info
date +%c
whoami
magisk -c
echo $APATCH
getprop ro.product.cpu.abi
getprop ro.product.cpu.abilist

# Log results for stock OpenSSL binary
SSL=openssl
SSLBin=$(which $SSL)
ls -lZ $SSLBin
Version=$($SSLBin version)

set +x
exec 1>&3 2>&4 3>&- 4>&-
