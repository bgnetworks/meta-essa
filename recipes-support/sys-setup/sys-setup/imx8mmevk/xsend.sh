#!/bin/bash

DEV=/dev/ttymxc1
BAUDRATE=115200

stty -F $DEV $BAUDRATE
sx /data/caam/enckey.bb >$DEV <$DEV
