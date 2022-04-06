BASE := $(shell git rev-parse --show-toplevel)
TOP := $(BASE)/vcu128

# set this variable to "https" to use https git clone
GIT_CLONE_STYLE ?= ssh

ifeq ($(GIT_CLONE_STYLE),ssh)
  GITHUB    :=git@github.com:
else ifeq ($(GIT_CLONE_STYLE),https)
  GITHUB    :=https://github.com/
endif

rtl_dir := $(TOP)/rtl
rtl_url := $(GITHUB)black-parrot/black-parrot
rtl_commit := 2f5ebd66
# 2f5ebd66 - me_dev before bump to latest dev

sdk_dir := $(TOP)/sdk
sdk_url := $(GITHUB)black-parrot-sdk/black-parrot-sdk
sdk_commit := 1d1c9fd
# 1d1c9fd - linux bump plus splash3

xdma_dir := $(TOP)/tools
xdma_url := $(GITHUB)muwyse/dma_ip_drivers
xdma_commit := 8d3686d

# set this variable to point to correct vivado binary
# the vcu128 design assumes version 2019.1
vivado_bin := $(XILINX_VIVADO)/bin/vivado

# set this variable to specify vivado project name
PROJECT_NAME ?= vcu128_bp
project_dir := $(TOP)/$(PROJECT_NAME)
project_xpr := $(project_dir)/$(PROJECT_NAME).xpr
build_tcl := $(TOP)/bp_fpga.tcl

script_dir := $(TOP)/script
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
	git -c $(rtl_dir) checkout -b vcu128 $(rtl_commit)

clone_sdk:
	git clone $(sdk_url) $(sdk_dir)
	git -c $(sdk_dir) checkout -b vcu128 $(sdk_commit)

clone_xdma:
	git clone $(xdma_url) $(xdma_dir)
	git -c $(xdma_dir) checkout -b vcu128 $(xdma_commit)

prep:
	$(MAKE) -C $(rtl_dir) libs
	$(MAKE) -C $(rtl_dir) tools
	$(MAKE) -C $(sdk_dir) sdk
	$(MAKE) -C $(sdk_dir) bedrock
	$(MAKE) -C $(sdk_dir) prog
	#$(MAKE) -C $(sdk_dir) linux

build:
	$(vivado_bin) -mode batch -source $(build_tcl) -tclargs --project_name $(PROJECT_NAME)

open:
	$(vivado_bin) $(project_xpr) &

JOBS ?= 8
generate_bitstream:
	$(vivado_bin) -mode batch -source $(generate_tcl) -tclargs --project_name $(PROJECT_NAME) --jobs $(JOBS)

copy_bitstream:
	-cp $(project_dir)/$(PROJECT_NAME).runs/impl_1/design_1_wrapper.bit .
	-cp $(project_dir)/$(PROJECT_NAME).runs/impl_1/design_1_wrapper.ltx .

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
