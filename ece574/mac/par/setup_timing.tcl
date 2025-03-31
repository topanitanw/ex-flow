# we don't have this .captable file
# create_rc_corner -name typical \
#    -cap_table "$env(ECE5745_STDCELLS)/rtk-typical.captable" \
#    -T 25
#
#
# Notice that we are loading in the “typical” captable and we are specifying
# an “average” operating temperature of 25 degC.
create_rc_corner \
    -name typical \
    -T 25

# load the lib file
create_library_set \
    -name libs_typical \
    -timing [list "../lib/NangateOpenCellLibrary_typical.lib"]

# specify a specific corner / case for timing analysis
create_delay_corner \
    -name delay_default \
    -early_library_set libs_typical \
    -late_library_set libs_typical \
    -rc_corner typical

# load the constraint file
create_constraint_mode \
    -name constraints_default \
    -sdc_files [list ../constraints/constraints_clk.sdc]

create_analysis_view \
    -name analysis_default \
    -constraint_mode constraints_default \
    -delay_corner delay_default

set_analysis_view \
    -setup [list analysis_default] \
    -hold [list analysis_default]
