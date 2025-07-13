module top_module(
	input clk,
	input rst,
	input start,
    input [6:0]data_in,
	input p_sel,

    output tx,
    output [6:0]data_out,
	output p_err);


wire baud_tick;
baud_tick uut_b( .clk(clk),
	   	 .rst(rst),
	   	 .baud_tick(baud_tick));

UART_tx   uut_t( .clk(clk),
	   	 .rst(rst),
	   	 .start(start),
	   	 .data_in(data_in),
	  	 .p_sel(p_sel),
		 .baud_tick(baud_tick),
	   	 .tx(tx));

UART_rx   uut_r( .clk(clk),
	  	 .rst(rst),
	  	 .baud_tick(baud_tick),
	  	 .rx(rx),
	   	 .p_err(p_err),
	   	 .data_out(data_out));
assign rx=tx;
endmodule
