#
# Create the Vivado project for the SCU35 demo design.
#
# Usage:
#   vivado -mode batch -source .\create_project.tcl
#
# This script resolves the project root relative to the current script, cleans
# stale build artifacts, creates a fresh Vivado project under <project>/build,
# and adds the demo RTL and constraint files.
#
# The design targets the SCU35 board part, so the board support package must be
# installed in Vivado before running the script.
#

# Resolve the project root (one level above this script) and set the output dir.
set project_root [file normalize [file join [file dirname [info script]] ..]]
set project_dir [file join $project_root build]

# Require the SCU35 board definition to be available in the current Vivado install.
set board_part_id xilinx.com:scu35:part0:1.0
set board_parts [get_board_parts -quiet $board_part_id]
if {[llength $board_parts] == 0} {
	error "SCU35 board part $board_part_id is unavailable; install device support for xcsu35p-sbvb625-2-e."
}

# Remove generated files from previous runs before creating the project.
source [file join [file dirname [file normalize [info script]]] clean_project.tcl]

# Create a new Vivado project named "demo" in the build directory and assign the board.
create_project -force demo $project_dir
set_property board_part $board_part_id [current_project]

# Import the top-level VHDL sources and constraints.
add_files [file join $project_root rtl scu35_demo_pkg.vhd]
add_files [file join $project_root rtl scu35_demo.vhd]
set_property top scu35_demo [current_fileset]
add_files -fileset constrs_1 [file join $project_root constraints scu35.xdc]

# Ensure the source compilation order is updated for the newly added files.
update_compile_order -fileset sources_1