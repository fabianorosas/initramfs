#!/bin/sh

/bin/busybox --install
mount -t proc proc proc
mount -t devtmpfs devtmpfs dev
mount -t sysfs sysfs sys
mount -t debugfs none sys/kernel/debug
/bin/sh
