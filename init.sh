#!/bin/sh

/bin/busybox --install
mount -t proc proc proc
mount -t devtmpfs devtmpfs dev
mount -t sysfs sysfs sys
mount -t debugfs none sys/kernel/debug
# https://busybox.net/FAQ.html#job_control
setsid /bin/sh -c 'exec sh </dev/hvc0 >/dev/hvc0 2>&1'
