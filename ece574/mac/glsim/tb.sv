module tb;
   logic [7:0] x1;
   logic [7:0] x2;
   logic [9:0] m;
   logic [9:0] y;
   logic reset;
   logic clk;

`ifdef USE_SDF
   initial
     begin
        $sdf_annotate("../syn/outputs/mac_delays.sdf",tb.dut,,"sdf.log","MAXIMUM");

     end
`endif

   mac dut(.x1(x1), 
	   .x2(x2), 
	   .m(m), 
	   .y(y), 
	   .reset(reset), 
	   .clk(clk));
   
   always
   begin
      clk = 1'b0;
      #5 clk = 1'b1;
      #5;
   end


   logic [15:0] test_m;
   logic [9:0] test_y;   
   
   initial
   begin
      $dumpfile("trace.vcd");
      $dumpvars(0, tb);
      x1 = 8'b0;
      x2 = 8'b0;
      test_m = 10'b0;
      test_y = 10'b0;
      
      reset = 1'b1;
      repeat(3)
         @(posedge clk);
      #1;      
      reset = 1'b0;

      $display("m %d y %d", m, y);
      
      repeat(30)
	begin
	   x1 = $random;
	   x2 = $random;
           @(posedge clk);
	   #1;      

	   test_m = (x1 * x2) >> 6;
	   test_y = test_y + test_m;
	   $display("x1 %d x2 %d m %d y %d exp_m %d exp_y %d ERR %d", 
		    x1, x2, m, y, test_m, test_y, ~((test_m == m) && (test_y == y)));
	   #1;
	end // repeat (30)
      
      $finish;
   end
   
endmodule
