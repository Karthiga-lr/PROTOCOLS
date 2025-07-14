module UART_tb;
	reg clk;
	reg rst;
	reg start;
    reg [6:0]data_in;
	reg p_sel;
	wire tx;
    wire [6:0]data_out;
	wire p_err;

top_module uut(clk,rst,start,data_in,p_sel,tx,data_out,p_err);

initial begin
	clk=0;
	forever #10 clk = ~clk ;
end
initial begin
  rst = 1;
  start = 0;
  data_in = 7'b0000000;
  p_sel = 1;

  #100;
  rst = 0;
  #100;
  data_in = 7'b1010101;
  #20;
  start = 1;

  #100_000_000;
  $finish;

end
initial begin
	$dumpfile("dump.vcd");
	$dumpvars;
end
endmodule
