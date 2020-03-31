THIS_DIR :=$(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

GIT_CLONE_STYLE :=ssh
#GIT_CLONE_STYLE :=https

ifeq ($(GIT_CLONE_STYLE),ssh)
  GITHUB    :=git@github.com:
  BITBUCKET :=git@bitbucket.com:
else ifeq ($(GIT_CLONE_STYLE),https)
  GITHUB    :=https://github.com/
  BITBUCKET :=https://bitbucket.com/
endif

tapeout_dir     :=$(THIS_DIR)/bsg_tapeout_v1_tsmc40
tapeout_url     :=$(GITHUB)black-parrot-examples/bsg_tapeout_v1_tsmc40
tapeout_commit  :=rc0

toplevel_dir := $(tapeout_dir)/toplevels/bsg_ac_black_parrot_quad_core_rc3

black_parrot_dir := $(toplevel_dir)/pre-alpha-release
black_parrot_commit := 396efdb

basejump_stl_dir := $(toplevel_dir)/basejump_stl
basejump_stl_commit := tapeout_bp_rc3
basejump_stl_dmc_commit := dev_bsg_dmc


vivado_bin := $(XILINX_VIVADO)/bin/vivado

project_dir := $(THIS_DIR)/vu37p_test
project_xpr_dir := $(project_dir)/vu37p_test.xpr
build_tcl_dir := $(THIS_DIR)/bp_fpga.tcl

script_dir := $(THIS_DIR)/script
generate_tcl := $(script_dir)/generate_bitstream.tcl
program_tcl_dir := $(script_dir)/program_fpga.tcl
update_tcl_dir := $(script_dir)/update_tcl.tcl



all: libs

libs: $(tapeout_dir)

$(tapeout_dir):
	git clone $(tapeout_url) $(tapeout_dir)
	cd $(tapeout_dir); git checkout $(tapeout_commit)
	cd $(toplevel_dir); make all
	cd $(black_parrot_dir); git checkout $(black_parrot_commit)
	cd $(basejump_stl_dir); git checkout $(basejump_stl_dmc_commit); git checkout $(basejump_stl_commit); git checkout -b $(basejump_stl_commit)_$(basejump_stl_dmc_commit); git merge $(basejump_stl_dmc_commit) --no-edit

build: $(project_dir)

$(project_dir): libs $(build_tcl_dir)
	cd $(black_parrot_dir); make ucode
	$(vivado_bin) -mode batch -source $(build_tcl_dir)

open:
	$(vivado_bin) $(project_xpr_dir) &

generate_bitstream:
	$(vivado_bin) -mode batch -source $(generate_tcl)

program_fpga:
	sudo $(vivado_bin) -mode batch -source $(program_tcl_dir) -tclargs $(XVC_URL)

update_tcl:
	$(vivado_bin) -mode batch -source $(update_tcl_dir)

clean_libs: are_you_sure
	rm -rf $(tapeout_dir)

clean_build: are_you_sure
	rm -rf $(project_dir)

DISABLE_SAFETY_PROMPT ?= false
are_you_sure:
	@$(DISABLE_SAFETY_PROMPT) || (echo -n "Are you sure [Y/n]? " && read ans && ([ "$$ans" == "Y" ] || [ "$$ans" == "y" ]))
