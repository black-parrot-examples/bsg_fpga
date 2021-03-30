# This tcl script will:
# 1. setup variables
# 2. setup VCS as a simulator
# 3. create a project
# 4. add BP to IP catalog
# 5. setup VCS flags

# set your paths and variables, please replace <> with the appropriate values
set bp_ip_path  <path_to_your_bp_ip_location>
set vcs_bin_path <path_to_vcs_bin>
set vcs_lib_path <path_to_where_you_want_your_compiled_vcs_lib>
set ::env(VCS_HOME) <path_to_your_vcs_home>
set ::env(LM_LICENSE_FILE) <your_license_key>
set proj_name <proj_name_of_your_choice>
set proj_path <path_to_your_proj>

# compile vcs library to use vcs as a simulator in Vivado
compile_simlib -simulator vcs -simulator_exec_path $vcs_bin_path -family all -language all -library all -dir $vcs_lib_path -no_ip_compile

# project creation
create_project $proj_name $proj_path -part xc7k325tffg900-2
set_property board_part digilentinc.com:genesys2:part0:1.1 [current_project]

# add BP to IP catalog
set_property  ip_repo_paths  $bp_ip_path [current_project]
update_ip_catalog

# setting vcs compilation and elaboration flags as well as changing the simulation runtime to 1ms
set_property target_simulator VCS [current_project]
set_property compxlib.vcs_compiled_library_dir $vcs_lib_path [current_project]
set_property -name {vcs.compile.vlogan.more_options} -value {-V +v2k -sverilog -assert svaext +lint=TFIPC-L} -objects [get_filesets sim_1]
set_property -name {vcs.elaborate.vcs.more_options} -value {-sverilog -assert svaext -lca +lint=TFIPC-L +noportcoerce} -objects [get_filesets sim_1]
set_property -name {vcs.simulate.runtime} -value {1ms} -objects [get_filesets sim_1]
set_property -name {vcs.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]




