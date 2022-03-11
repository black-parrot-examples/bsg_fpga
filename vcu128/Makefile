THIS_DIR :=$(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

GIT_CLONE_STYLE :=ssh
#GIT_CLONE_STYLE :=https

ifeq ($(GIT_CLONE_STYLE),ssh)
  GITHUB    :=git@github.com:
else ifeq ($(GIT_CLONE_STYLE),https)
  GITHUB    :=https://github.com/
endif

rtl_dir := $(THIS_DIR)/rtl
rtl_url := $(GITHUB)black-parrot/black-parrot
rtl_commit := f1a68bfe

sdk_dir := $(THIS_DIR)/sdk
sdk_url := $(GITHUB)black-parrot-sdk/black-parrot-sdk
sdk_commit := 758f976

xdma_dir := $(THIS_DIR)/tools
xdma_url := $(GITHUB)muwyse/dma_ip_drivers
xdma_commit := d496bb4

vivado_bin := $(XILINX_VIVADO)/bin/vivado

project_name ?= vcu128_bp
project_dir := $(THIS_DIR)/$(project_name)
project_xpr_dir := $(project_dir)/$(project_name).xpr
build_tcl := $(THIS_DIR)/bp_fpga.tcl

script_dir := $(THIS_DIR)/script
generate_tcl := $(script_dir)/generate_bitstream.tcl
program_tcl := $(script_dir)/program_fpga.tcl
update_tcl := $(script_dir)/update_tcl.tcl

.DEFAULT_GOAL: echo

echo:
	@echo "run make prep -j <N>; make build to build the FPGA project"
	@echo "this might take a while..."

# note: invoke each clone sequentially
libs:
	$(MAKE) clone_rtl
	$(MAKE) clone_sdk
	$(MAKE) clone_xdma

clone_rtl:
	git clone $(rtl_url) $(rtl_dir)
	cd $(rtl_dir) && git checkout -b vcu128 $(rtl_commit)
	cd $(THIS_DIR)

clone_sdk:
	git clone $(sdk_url) $(sdk_dir)
	cd $(sdk_dir) && git checkout -b vcu128 $(sdk_commit)
	cd $(THIS_DIR)

clone_xmda:
	git clone $(xdma_url) $(xdma_dir)
	cd $(xdma_dir) && git checkout -b vcu128 $(xdma_commit)
	cd $(THIS_DIR)

prep:
	$(MAKE) -C $(rtl_dir) libs
	$(MAKE) -C $(rtl_dir) tools
	$(MAKE) -C $(sdk_dir) sdk
	$(MAKE) -C $(sdk_dir) prog
	#$(MAKE) -C $(sdk_dir) linux

build: $(project_dir)
$(project_dir): $(build_tcl)
	$(MAKE) -C $(sdk_dir) bedrock
	$(vivado_bin) -mode batch -source $(build_tcl)

open:
	$(vivado_bin) $(project_xpr_dir) &

JOBS ?= 8
generate_bitstream:
	$(vivado_bin) -mode batch -source $(generate_tcl) -tclargs $(JOBS)

copy_bitstream:
	cp $(project_dir)/$(project_name).runs/impl_1/design_1_wrapper.bit .
	cp $(project_dir)/$(project_name).runs/impl_1/design_1_wrapper.ltx .

DATE:=$(shell date +"%c")
BITFILE ?= ./design_1_wrapper.bit
program_fpga:
	sudo $(vivado_bin) -mode batch -source $(program_tcl) -tclargs $(BITFILE)
	@echo "$(DATE): $(shell readlink -f $(BITFILE))" > last_programmed.txt

check_device:
	@lspci -vvv | grep -qE "Xilinx" && echo "FPGA found!" || "FPGA not found...try rebooting"

#update_tcl:
#	$(vivado_bin) -mode batch -source $(update_tcl)

clean_rtl: are_you_sure
	rm -rf $(rtl_dir)

clean_sdk: are_you_sure
	rm -rf $(sdk_dir)

clean_tools: are_you_sure
	rm -rf $(xdma_dir)

clean_build: are_you_sure
	rm -rf $(project_dir)

DISABLE_SAFETY_PROMPT ?= false
are_you_sure:
	@$(DISABLE_SAFETY_PROMPT) || (echo -n "Are you sure [Y/n]? " && read ans && ([ "$$ans" == "Y" ] || [ "$$ans" == "y" ]))
