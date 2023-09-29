#!/bin/sh

finish_enabled() {
	return 0
}

finish_run() {
	if [ -n "$ROOTFS_DIR" ]; then
		if [ ! -d $ROOTFS_DIR/dev ]; then
			fatal "ERROR: There's no '/dev' on rootfs."
		fi
		
		umount $KEYS_DIR/
		
		# Moving /dev, /proc and /sys onto rootfs
		mount --move /dev $ROOTFS_DIR/dev
		mount --move /proc $ROOTFS_DIR/proc
		mount --move /sys $ROOTFS_DIR/sys
		
		# Switching root to '$ROOTFS_DIR'
		cd $ROOTFS_DIR
		exec switch_root $ROOTFS_DIR ${bootparam_init:-/sbin/init}
	else
		fatal "No rootfs has been set"
	fi
}
