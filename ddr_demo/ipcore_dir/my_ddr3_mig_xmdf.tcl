# The package naming convention is <core_name>_xmdf
package provide my_ddr3_mig_xmdf 1.0

# This includes some utilities that support common XMDF operations 
package require utilities_xmdf

# Define a namespace for this package. The name of the name space
# is <core_name>_xmdf
namespace eval ::my_ddr3_mig_xmdf {
# Use this to define any statics
}

# Function called by client to rebuild the params and port arrays
# Optional when the use context does not require the param or ports
# arrays to be available.
proc ::my_ddr3_mig_xmdf::xmdfInit { instance } {
	# Variable containing name of library into which module is compiled
	# Recommendation: <module_name>
	# Required
	utilities_xmdf::xmdfSetData $instance Module Attributes Name my_ddr3_mig
}
# ::my_ddr3_mig_xmdf::xmdfInit

# Function called by client to fill in all the xmdf* data variables
# based on the current settings of the parameters
proc ::my_ddr3_mig_xmdf::xmdfApplyParams { instance } {

set fcount 0
	# Array containing libraries that are assumed to exist
	# Examples include unisim and xilinxcorelib
	# Optional
	# In this example, we assume that the unisim library will
	# be magically
	# available to the simulation and synthesis tool
	utilities_xmdf::xmdfSetData $instance FileSet $fcount type logical_library
	utilities_xmdf::xmdfSetData $instance FileSet $fcount logical_library unisim
	incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path my_ddr3_mig/user_design/rtl/infrastructure.v
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path my_ddr3_mig/user_design/rtl/mcb_controller/iodrp_controller.v
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path my_ddr3_mig/user_design/rtl/mcb_controller/iodrp_mcb_controller.v
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path my_ddr3_mig/user_design/rtl/mcb_controller/mcb_raw_wrapper.v
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path my_ddr3_mig/user_design/rtl/mcb_controller/mcb_soft_calibration.v
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path my_ddr3_mig/user_design/rtl/mcb_controller/mcb_soft_calibration_top.v
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path my_ddr3_mig/user_design/rtl/mcb_controller/mcb_ui_top.v
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path my_ddr3_mig/user_design/rtl/memc_wrapper.v
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path my_ddr3_mig/user_design/rtl/my_ddr3_mig.v
utilities_xmdf::xmdfSetData $instance FileSet $fcount type verilog
incr fcount

utilities_xmdf::xmdfSetData $instance FileSet $fcount relative_path my_ddr3_mig/user_design/par/my_ddr3_mig.ucf
utilities_xmdf::xmdfSetData $instance FileSet $fcount type ucf 
utilities_xmdf::xmdfSetData $instance FileSet $fcount associated_module my_ddr3_mig
incr fcount

}

# ::gen_comp_name_xmdf::xmdfApplyParams
