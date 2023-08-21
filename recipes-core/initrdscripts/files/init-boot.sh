#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

udev_daemon() {
	OPTIONS="/sbin/udev/udevd /sbin/udevd /lib/udev/udevd /lib/systemd/systemd-udevd"

	for o in $OPTIONS; do
		if [ -x "$o" ]; then
			echo $o
			return 0
		fi
	done

	return 1
}

_UDEV_DAEMON=`udev_daemon`

mkdir -p /proc /sys /run /var/run
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs none /dev

# support modular kernel
modprobe isofs 2> /dev/null

$_UDEV_DAEMON --daemon
udevadm trigger --action=add

exec sh

