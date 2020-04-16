EXT_DIR=external

.PHONY: all
all: initramfs.img

BINS=trace-cmd lsprop drmgr

# make them all at once so that we can use -j in the cmdline
bins:
	+make -C $(EXT_DIR) $(BINS)

$(BINS) busybox:
	+make -C $(EXT_DIR) $@

prog_list: busybox init.sh
	$(file >$@) \
	$(foreach prog,$(BINS) $^, \
		$(file >>$@,file /bin/$(prog) $(prog) 755 0 0))

rootfs_contents: default_contents bins prog_list
	$(file >>$@,$(file <default_contents)$(file <prog_list))
	rm prog_list

gen_init_cpio: $(EXT_DIR)/gen_init_cpio

initramfs.img: gen_init_cpio rootfs_contents
	$(EXT_DIR)/gen_init_cpio rootfs_contents | gzip > initramfs.img

clean:
	-rm initramfs.img
	-rm rootfs_contents
	-rm prog_list
	+make -C $(EXT_DIR) clean

distclean: clean
	-rm busybox
	-rm $(BINS)
	+make -C $(EXT_DIR) distclean

.PHONY: bins
.PHONY: initramfs.img
.PHONY: clean
.PHONY: distclean
FORCE:
