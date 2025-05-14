#!/bin/sh

#
# Перенос в TARGET модулей ядра
#

export WRT="/tmp/openwrt_unpacked"
rm -rf $WRT &> /dev/null
mkdir $WRT
tar xf $_FILES/openwrt.tgz -C $WRT
cp $WRT/lib/modules $TARGET/lib/ -r
mkdir $TARGET/etc/modules-load.d
cp $WRT/etc/modules.d/* $TARGET/etc/modules-load.d
cd $TARGET/etc/modules-load.d; for name in $(ls); do mv $name $name.conf; done
