CC		= gcc
LDFLAGS_BUSYBOX  = --static
LDFLAGS_TRACE_CMD = -static

EXT_DIR=external
BUSYBOX_DIR=$(EXT_DIR)/busybox
TRACE_CMD_DIR=$(EXT_DIR)/trace-cmd

.PHONY: all
all: initramfs.img

busybox: $(BUSYBOX_DIR)/Makefile
	make -C $(BUSYBOX_DIR) defconfig
	make -C $(BUSYBOX_DIR) LDFLAGS=$(LDFLAGS_BUSYBOX)
	mv $(BUSYBOX_DIR)/busybox .

$(BUSYBOX_DIR)/Makefile:
	git submodule update --init $(BUSYBOX_DIR)

trace-cmd: $(TRACE_CMD_DIR)/Makefile
	make -C $(TRACE_CMD_DIR) LDFLAGS=$(LDFLAGS_TRACE_CMD)
	mv $(TRACE_CMD_DIR)/tracecmd/trace-cmd .

$(TRACE_CMD_DIR)/Makefile:
	git submodule update --init $(TRACE_CMD_DIR)

gen_init_cpio: $(EXT_DIR)/gen_init_cpio.c
	$(CC) -o $@ $(EXT_DIR)/gen_init_cpio.c

initramfs_list: busybox trace-cmd init.sh

.PHONY: initramfs.img
initramfs.img: gen_init_cpio initramfs_list
	./gen_init_cpio initramfs_list | gzip > initramfs.img

.PHONY: clean
clean:
	rm -f gen_init_cpio
	rm -f initramfs.img
	make -C $(TRACE_CMD_DIR) clean

.PHONY: distclean
distclean: clean
	rm -f busybox trace-cmd
	make -C $(BUSYBOX_DIR) distclean
