#!/bin/bash

#
# Фирмварь для gtw360
#

cp $_FILES/firmware $TARGET/lib -r
chown root:root $TARGET/lib/firmware
