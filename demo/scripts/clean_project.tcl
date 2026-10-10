#
# Remove generated Vivado project files for the SCU35 demo design.
#
# Usage:
#   vivado -mode batch -source .\clean_project.tcl
#
# Paths are resolved relative to this script, so it can be run from any
# working directory.
#

set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ..]]
set project_dir [file join $project_root build]

# Remove the generated project and its build products.
if {[file exists $project_dir]} {
	file delete -force $project_dir
}

# Remove Vivado logs and journals from the project and scripts directories.
foreach stale_dir [lsort -unique [list $project_root $script_dir]] {
	foreach stale_file [glob -nocomplain -directory $stale_dir *.backup.log *.backup.jou] {
		file delete -force $stale_file
	}
}
