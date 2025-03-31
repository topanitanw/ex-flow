all: syn

syn:
	BASENAME=mac \
		CLOCKPERIOD=4 \
		TIMINGPATH='../lib' \
		TIMINGLIB='../lib/NangateOpenCellLibrary_typical.lib' \
		VERILOG='../rtl/mac.sv' \
		genus -f genus_script.tcl

clean:
	rm -rf outputs reports genus.log* genus.cmd* *~ fv

