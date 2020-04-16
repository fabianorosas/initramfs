CC		= gcc

BUSYBOX_DIR=busybox
BUSYBOX_BIN=$(BUSYBOX_DIR)/busybox
LDFLAGS_BUSYBOX  = --static

TRACE_CMD_DIR=trace-cmd
TRACE_CMD_BIN=$(TRACE_CMD_DIR)/tracecmd/trace-cmd
LDFLAGS_TRACE_CMD = -static

LIBRTAS_DIR=librtas
LDFLAGS_LIBRTAS = -static

POWERPC_UTILS_DIR=powerpc-utils
RTAS_LIBS=librtas/.libs
LDFLAGS_POWERPC_UTILS = "-static -L../$(RTAS_LIBS)"
LSPROP_BIN=$(POWERPC_UTILS_DIR)/src/lsprop
DRMGR_BIN=$(POWERPC_UTILS_DIR)/src/drmgr/drmgr

#DEVNULL=&> /dev/null

$(BUSYBOX_DIR): $(BUSYBOX_BIN)
$(BUSYBOX_BIN):
	git submodule update --init busybox
	+make -C busybox defconfig $(DEVNULL)
	+make -C busybox LDFLAGS=$(LDFLAGS_BUSYBOX) $(DEVNULL)
	mv $(BUSYBOX_BIN) ..
	@echo

$(TRACE_CMD_DIR): $(TRACE_CMD_BIN)
$(TRACE_CMD_BIN):
	git submodule update --init trace-cmd
	+make -C trace-cmd LDFLAGS=$(LDFLAGS_TRACE_CMD) $(DEVNULL)
	mv $(TRACE_CMD_BIN) ..
	@echo

.PHONY: librtas
librtas: $(RTAS_LIBS)
$(RTAS_LIBS):
	git submodule update --init librtas
	cd librtas; ./autogen.sh $(DEVNULL); ./configure $(DEVNULL)
	+make -C librtas LDFLAGS=$(LDFLAGS_LIBRTAS) $(DEVNULL)
	@echo

lsprop: | $(POWERPC_UTILS_DIR)/Makefile
	cp $(LSPROP_BIN) ..

drmgr: | $(POWERPC_UTILS_DIR)/Makefile
	cp $(DRMGR_BIN) ..

.PHONY: $(POWERPC_UTILS_DIR)
$(POWERPC_UTILS_DIR): $(POWERPC_UTILS_DIR)/Makefile
$(POWERPC_UTILS_DIR)/Makefile: | $(RTAS_LIBS)
	git submodule update --init powerpc-utils
	cd powerpc-utils; ./autogen.sh $(DEVNULL); ./configure $(DEVNULL)
	+make -C powerpc-utils LDFLAGS=$(LDFLAGS_POWERPC_UTILS) $(DEVNULL)
	@echo

gen_init_cpio: gen_init_cpio.c

.PHONY: clean
clean:
	-rm gen_init_cpio
	+make -C $(BUSYBOX_DIR) clean
	+make -C $(TRACE_CMD_DIR) clean
	+make -C $(LIBRTAS_DIR) clean
	+make -C $(POWERPC_UTILS_DIR) clean

.PHONY: distclean
distclean: clean
	+make -C $(BUSYBOX_DIR) distclean
	+make -C $(LIBRTAS_DIR) distclean
	+make -C $(POWERPC_UTILS_DIR) distclean

.SUFFIXES:
