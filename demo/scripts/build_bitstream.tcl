#
# Build the SCU35 demo bitstream from the generated Vivado project.
#
# Usage:
#   vivado -mode batch -source .\build_bitstream.tcl
#
# This script expects the project created by scripts/create_project.tcl to exist,
# verifies the selected part and top module, runs synthesis if needed, and then
# runs implementation through the write_bitstream stage to produce the final .bit
# file for the SCU35 demo.
#
# The script fails early if the project is missing, the board part does not match
# the SCU35 target, or the expected top-level module is not set.
#

# Resolve paths relative to this script and locate the Vivado project file.
set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ..]]
set project_file [file join $project_root build demo.xpr]
set expected_part xcsu35p-sbvb625-2-e
set expected_top scu35_demo

# Require the project to exist before starting any build work.
if {![file exists $project_file]} {
  error "Project not found at $project_file; run scripts/create_project.tcl first."
}

# Open the project and verify the configuration matches the expected SCU35 design.
open_project $project_file
if {[get_property PART [current_project]] ne $expected_part} {
  error "Unexpected project part: [get_property PART [current_project]]"
}
if {[get_property TOP [current_fileset]] ne $expected_top} {
  error "Unexpected project top: [get_property TOP [current_fileset]]"
}

# Refresh compile ordering before starting synthesis or implementation.
update_compile_order -fileset sources_1

# Run synthesis if it has not already completed successfully.
set synth_status [get_property STATUS [get_runs synth_1]]
if {![string match "*Complete*" $synth_status]} {
  reset_run synth_1
  launch_runs synth_1 -jobs 8
  wait_on_run synth_1
  set synth_status [get_property STATUS [get_runs synth_1]]
  if {![string match "*Complete*" $synth_status]} {
    error "Synthesis did not complete successfully: $synth_status"
  }
}

# Determine the implementation output directory and expected bitstream path.
set impl_dir [get_property DIRECTORY [get_runs impl_1]]
set bitstream_file [file join $impl_dir "${expected_top}.bit"]
set impl_status [get_property STATUS [get_runs impl_1]]

# Run implementation through the write_bitstream stage if it has not already been
# completed or if the bitstream file is missing.
if {![string match "*write_bitstream Complete*" $impl_status] || ![file exists $bitstream_file]} {
  launch_runs impl_1 -to_step write_bitstream -jobs 8
  wait_on_run impl_1
  set impl_status [get_property STATUS [get_runs impl_1]]
  if {![string match "*Complete*" $impl_status]} {
    error "Implementation did not complete successfully: $impl_status"
  }
}

# Confirm that the final bitstream file exists before returning success.
if {![file exists $bitstream_file]} {
  error "Implementation completed without producing $bitstream_file"
}

puts "BITSTREAM_FILE=$bitstream_file"
close_project