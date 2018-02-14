CC		= gcc
LDFLAGS_BUSYBOX  = --static

EXT_DIR=external
BUSYBOX_DIR=$(EXT_DIR)/busybox

.PHONY: all
all: initramfs.img

busybox: $(BUSYBOX_DIR)/Makefile
	git submodule update $(BUSYBOX_DIR)
	make -C $(BUSYBOX_DIR) defconfig
	make -C $(BUSYBOX_DIR) LDFLAGS=$(LDFLAGS_BUSYBOX)
	mv $(BUSYBOX_DIR)/busybox .

gen_init_cpio: $(EXT_DIR)/gen_init_cpio.c
	$(CC) -o $@ $(EXT_DIR)/gen_init_cpio.c

initramfs_list: busybox init.sh

.PHONY: initramfs.img
initramfs.img: gen_init_cpio initramfs_list
	./gen_init_cpio initramfs_list | gzip > initramfs.img

.PHONY: clean
clean:
	rm -f gen_init_cpio
	rm -f initramfs.img

.PHONY: distclean
distclean: clean
	rm -f busybox
	make -C $(BUSYBOX_DIR) distclean
