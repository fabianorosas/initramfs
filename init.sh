#!/bin/sh

/bin/busybox --install
mount -t proc proc proc
mount -t devtmpfs devtmpfs dev
mount -t sysfs sysfs sys
/bin/sh
