# Set up environment variables and paths
set init_verilog "../syn/outputs/mac_netlist.v"  ;# Gate-level netlist
set init_top_cell "mac"                     ;# Name of the top module
set init_lef_file "../lib/NangateOpenCellLibrary.lef"  ;# LEF files
set init_gnd_net "VSS"                                ;# Ground net name
set init_pwr_net "VDD"                                ;# Power net name
set init_mmmc_file "setup_timing.tcl"         ;# Timing constraints file

# Initialize the design
init_design
# -verilog $init_verilog \
# -top_cell $init_top_cell \
# -lef_files $init_lef_file \
# -gnd_net $init_gnd_net \
# -pwr_net $init_pwr_net \
# -mmmc_file $init_mmmc_file
#
# Floorplanning (optional: adjust core area, aspect ratio, etc.)
# floorPlan command to set the dimensions for our chip.
# floorPlan -su 1.0 0.70 4.0 4.0 4.0 4.0
floorPlan -su 1.0 0.70 4.0 4.0 4.0 4.0

# tell Cadence Innovus that VDD and VSS in the gate-level netlist
# correspond to the physical pins labeled VDD and VSS in the .lef files.
globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose

# rails that go along each row of standard cells.
sroute -nets {VDD VSS}

# # create a power ring around our chip using the addRing command. A power ring
# # ensures we can easily get power and ground to all standard cells. The command
# # takes parameters specifying the width of each wire in the ring, the spacing
# # between the two rings, and what metal layers to use for the ring.
# addRing \
#     -nets {VDD VSS} \
#     -width 0.6 \
#     -spacing 0.5 \
#     -layer [list top 7 bottom 7 left 6 right 6]
#
# # We have power and ground rails along each row of standard cells and a power
# # ring, so now we need to hook these up. We can use the addStripe command to
# # draw wires and automatically insert vias whenever wires cross.
# addStripe \
#     -nets {VSS VDD} \
#     -layer 6 \
#     -direction vertical \
#     -width 0.4 \
#     -spacing 0.5 -set_to_set_distance 5 -start 0.5
#
# # draw the vertical “stripes”.
# setAddStripeMode \
#     -stacked_via_bottom_layer 6 \
#     -stacked_via_top_layer    7
#
# # draw the horizontal “stripes”.
# addStripe \
#     -nets {VSS VDD} \
#     -layer 7 \
#     -direction horizontal \
#     -width 0.4 -spacing 0.5 -set_to_set_distance 5 -start 0.5


# Placement
#  do the initial placement and routing of the standard cells using the
#  place_design command:
#  innovus raises an error that this command is invalid.
placeDesign

# Clock tree synthesis (CTS)
# create_clock_tree_spec -output Clock.ctstch
setCTSMode -routeGuide true
setCTSMode -routeClkNet true
clockDesign -outDir ./clock_report
# do clock tree synthesis optimization to improve the quality of the clock tree
# (e.g., less clock skew across the chip). Before running the command make sure
# you can see the physical view of the chip, and then watch how the clock net
# changes after the command is complete.
ccopt_design

# Routing
routeDesign

# Optimization and timing closure
# innovus stopped executing due to the invalid return code.
# optDesign

# Verify the design (DRC, LVS, etc.)
#  We can do this using the verifyConnectivity command. We can also do a
#  preliminary “design rule check” to make sure that the generated metal
#  interconnect does not violate any design rules with the verify_drc command.
verifyConnectivity
verify_drc
# verify_lvs

# Save final outputs
# write_def final.def                     ;# DEF file for physical layout
# write_gds final.gds                     ;# GDSII file for fabrication
streamOut final.gds
# write_verilog final_post_pnr.v          ;# Post-layout netlist with parasitics
# write_spef final.spef                   ;# SPEF file for parasitic extraction

write_sdf post-pnr.sdf -interconn all -setuphold split
report_timing > timing.rpt
report_area > area.rpt
report_power -hierarchy all > power.rpt
exit
