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

black_parrot_dir := $(THIS_DIR)/black-parrot
black_parrot_url := $(GITHUB)black-parrot/black-parrot
black_parrot_commit := c7f47ef


vivado_bin := $(XILINX_VIVADO)/bin/vivado

project_dir := $(THIS_DIR)/vu37p_test
project_xpr_dir := $(project_dir)/vu37p_test.xpr
build_tcl_dir := $(THIS_DIR)/bp_fpga.tcl

script_dir := $(THIS_DIR)/script
generate_tcl := $(script_dir)/generate_bitstream.tcl
program_tcl_dir := $(script_dir)/program_fpga.tcl
update_tcl_dir := $(script_dir)/update_tcl.tcl



all: libs

libs: $(black_parrot_dir)

$(black_parrot_dir):
	git clone $(black_parrot_url) $(black_parrot_dir)
	cd $(black_parrot_dir); git checkout $(black_parrot_commit)

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
	rm -rf $(black_parrot_dir)

clean_build: are_you_sure
	rm -rf $(project_dir)

DISABLE_SAFETY_PROMPT ?= false
are_you_sure:
	@$(DISABLE_SAFETY_PROMPT) || (echo -n "Are you sure [Y/n]? " && read ans && ([ "$$ans" == "Y" ] || [ "$$ans" == "y" ]))