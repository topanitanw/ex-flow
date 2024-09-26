module mac(
    input [7:0] x1,
    input [7:0] x2,
    output reg [9:0] y,
    output reg [9:0] m,
    input  reset,
    input  clk
);

   reg [9:0] y_next;
   reg [15:0] m16;

   always @(posedge clk)
       if (reset)
         y <= 10'b0;
       else
         y <= y_next;

   always @(*)
     begin
        m16 = x1 * x2;
        m = m16[15:6];
        y_next = y + m;
     end

endmodule
