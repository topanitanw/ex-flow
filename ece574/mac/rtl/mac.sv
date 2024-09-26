module mac(
    input logic [7:0] x1,
    input logic [7:0] x2,
    output logic [9:0] y,
    output logic [9:0] m,
    input logic reset,
    input logic clk
);

   logic [9:0] y_next;
   logic [15:0] m16;
   
   always_ff @(posedge clk)
       if (reset)
	 y <= 10'b0;
       else
	 y <= y_next;
      
   always_comb
     begin
	m16 = x1 * x2;  
	m = m16[15:6];
	y_next = y + m;
     end
   
endmodule
