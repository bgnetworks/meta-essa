#!/bin/bash

DEV=/dev/ttymxc0
BAUDRATE=115200

stty -F $DEV $BAUDRATE
rz  >$DEV <$DEV
