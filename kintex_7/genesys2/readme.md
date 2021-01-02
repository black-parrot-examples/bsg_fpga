# BlackParrot FPGA Simulation
This directory contains scripts that will help you setup a quick simulation with BlackParrot on Vivado.

## Tools Requirement:
Xilinx Vivado (preferably 2019.1 or newer)
VCS-MX (Optional, 2018 or newer)

## Directory Breakdown
The bp_packaged_IP contains all of the IP related files while the script directory contains tcl scripts for Vivado. The scripts are broken into 3 parts so that the tool is not doing too much at once.

####bp_packaged_IP:
- src: all of the source files needed for BlackParrot IP
- tb: all of the simulation files for BlackParrot IP

####script:
- proj_setup.tcl: sets up a Vivado project and VCS simulator
- bd_setup.tcl: sets up a BlackParrot block diagram design
- sim_launch.tcl launches a simulation

## How to run:
1) before you start, read the simulation guide
2) open up the proj_setup.tcl and replace all of the values in < > with the appropriate value
3) after entering `vivado &` to start a Vivado project, enter `source proj_setup.tcl` in the Vivado tcl console to run the scripts
4) once the project is created, enter `source bd_setup.tcl` to set up a block design
5) once the block design is completed, enter `source sim_launch.tcl` to launch a simulation
6) the simulation will run the default prog.nbf file located in the bp_packaged_IP/tb directory. The file is defaulted to hello_world

## Version:
The current version of this IP is BlackParrot_v0_2020_12_22 
