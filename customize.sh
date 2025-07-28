#!/system/bin/sh

# Magisk Module: OpenSSL-NDK v1.1.1l, supporting APatch and KSU
# Copyright (c) zgfg @ xda, 2024-
# Module installs static NDK OpenSSL v1.1.1l binary, supporting ARMv7 and higher.
# Credits to robertying @ github for pre-built libraries at https://github.com/robertying/openssl-curl-android/releases/tag/1.1.1l-7.78.0
# Test from Terminal Emulator:
# $ su -c which openssl
# $ su -c openssl help

if [ -z $BOOTMODE ] || [ "$BOOTMODE" != "true" ] 
then
  abort "ERROR: Install from Magisk app, not from TWRP!"
fi

# Log file for debugging - uncomment for logging
#LogFile="$MODPATH/customize.log"
if [ ! -z $LogFile ]
then
  exec 3>&1 4>&2 2>$LogFile 1>&2
  set -x
  
  # Log info
  date +%c
  whoami
  magisk -c
  echo $APATCH
  getprop ro.product.cpu.abi
  getprop ro.product.cpu.abilist
fi

# Module's own path (local path)
cd $MODPATH
pwd

# OpenSSL ARMv7 and higher binaries
SSLBinList="
openssl-arm64-v8a
openssl-armeabi-v7a
"

# OpenSSL binary to be installed
SSL=openssl

# Find the applicable binary
SSLType=""
for SSLBin in $SSLBinList
do
  if [ -z $SSLType ] && [ -f $SSLBin ]
  then
    # Test if binary executes 
    echo "Testing archived $SSLBin"
    chmod 755 $SSLBin
    Version=$(./$SSLBin version)
    Found=$(echo "$Version" | grep -i $SSL)

    if [ -n "$Found" ]
    then
      # Applicable binary found
      SSLType=$SSLBin
      mv $SSLType $SSL
      chcon u:object_r:system_file:s0 $SSL
      echo "$Version $SSLType binary installed"
      continue
    fi
  fi

  # Delete binary (already found or doesn't execute)
  rm -f $SSLBin
done

if [ -z $SSLType ]
then
  # Applicable binary not found
  echo
  echo "ERROR: OpenSSL not installed!"
  echo
  echo "$(cat /proc/cpuinfo)"
  echo
  exit -1
fi

if [ ! -z $LogFile ]
then
  set +x
  exec 1>&3 2>&4 3>&- 4>&-
fi
