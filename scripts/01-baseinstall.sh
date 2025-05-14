#!/bin/sh

#
# Установка базы системы
#

debootstrap --arch armhf $RELEASE $TARGET $MIRROR
exit $?
