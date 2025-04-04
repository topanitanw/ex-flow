read_lib ../lib/NangateOpenCellLibrary_typical.lib

read_verilog ../syn/outputs/mac_netlist.v
set_top_module mac

read_sdc ../syn/outputs/mac_constraints.sdc
read_sdf ../syn/outputs/mac_delays.sdf

report_timing -late -max_paths 10 > late.rpt
report_timing -early -max_paths 10 > early.rpt

report_timing  -from [all_inputs] -to [all_outputs] -max_paths 10 -path_type summary  > allpaths.rpt
report_timing  -from [all_inputs] -to [all_registers] -max_paths 10 -path_type summary  >> allpaths.rpt
report_timing  -from [all_registers] -to [all_registers] -max_paths 10 -path_type summary >> allpaths.rpt
report_timing  -from [all_registers] -to [all_outputs] -max_paths 10 -path_type summary >> allpaths.rpt
exit
