#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

ROOTFS_DIR="/rootfs"
MODULE_DIR=/init.d

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

fatal() {
    echo $1 >/dev/console
    echo >/dev/console

    while [ "true" ]; do
        sleep 3600
    done
}

mkdir $ROOTFS_DIR
mkdir -p /proc /sys /run /var/run
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs none /dev

# support modular kernel
modprobe isofs 2> /dev/null

$_UDEV_DAEMON --daemon
udevadm trigger --action=add

for m in $MODULE_DIR/*; do
	#Get module base name
	module=`basename $m | cut -d'-' -f 2`

	#process module
	. $m

	if ! eval "${module}_enabled"; then
		echo "Skipping module ${module}"
		continue
	fi

	echo "Calling module ${module}"
	eval "${module}_run"
done

# Wait at the while loop after the encryption process executed
fatal "Encryption process executed"
