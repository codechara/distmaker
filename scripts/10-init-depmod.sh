#!/bin/sh

#
# init.depmod нужен для depmod'а всех модулей при первом включении
#

cat $_FILES/init.depmod > $TARGET/init
chmod 755 $TARGET/init
