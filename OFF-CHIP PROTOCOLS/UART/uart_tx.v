module uart_trans(
  input clk,
  input reset,
  input start,
  input [6:0] data_in,
  input p_sel,
  input baud_tick,
  output reg tx
);

  parameter IDLE = 3'b000,
            START = 3'b001,
            DATA = 3'b010,
            PARITY = 3'b011,
            STOP = 3'b100;

  reg [2:0] state, next_state;
  reg [2:0] count;
  reg parity;

  always @(posedge clk) begin
    if (reset)
      state <= IDLE;
    else
      state <= next_state;
  end

  
  always @(*) begin
    case (state)
      IDLE:    next_state = (start) ? START : IDLE;
      START:   next_state = (baud_tick) ? DATA : START;
      DATA:    next_state = (baud_tick && count == 6) ? PARITY : DATA;
      PARITY:  next_state = (baud_tick) ? STOP : PARITY;
      STOP:    next_state = (baud_tick) ? IDLE : STOP;
      default: next_state = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (reset) begin
      tx <= 1;
      count <= 0;
      parity <= 0;
    end else if (baud_tick) begin
      case (state)
        IDLE: begin
          tx <= 1;
          count <= 0;
        end
        START: tx <= 0;
        DATA: begin
          tx <= data_in[count];
          count <= count + 1;
          if (count == 6)
            parity <= (p_sel) ? ^data_in : ~(^data_in); 
        end
        PARITY: tx <= parity;
        STOP: tx <= 1;
      endcase
    end
  end

endmodule
module baud_tick(
	input clk,
	input reset,
	output reg baud_tick);
  
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
