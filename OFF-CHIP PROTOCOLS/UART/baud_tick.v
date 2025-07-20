module baud_tick(
	input clk,
	input reset,
	output reg baud_tick);
  //
parameter FRE       = 50_000_000;
parameter BAUD_RATE = 9600;
parameter COUNT_MAX = FRE / BAUD_RATE;

reg [13:0]count=0;

always@(posedge clk)begin
  if(reset)begin
		count  	  <= 0 ;
		baud_tick <= 0 ;
	end
	else if(count == COUNT_MAX - 1)begin
		count  	  <= 0;
		baud_tick <= 1;
	end
	else begin
		count 	  <= count+1;
		baud_tick <= 0;
	end
end
endmodule
