module APB_master (
  input wire pclk,
  input wire presetn,
  input wire transfer,
  input wire read_write,
  input wire [7:0] apb_write_padd,
  input wire [7:0] apb_write_data,
  input wire [7:0] apb_read_paddr,
  input wire [7:0] pr_data,
  input wire pready,
  
  output wire psel1,
  output reg penable,
  output wire pwrite,
  output wire [7:0] paddr,
  output wire [7:0] pwdata,
  output wire [7:0] apb_read_dat_out
);
  
  parameter IDLE = 2'd0,
            SETUP = 2'd1,
            ACCESS = 2'd2;
  
  reg [1:0] state, next_state;
  
  always @(posedge pclk or negedge presetn)
    if (!presetn)
      state <= IDLE;
    else
      state <= next_state;
  
  always @(*) begin
    case(state)
      IDLE: begin
        penable = 1'b0;
        if (transfer)
          next_state = SETUP;
        else
          next_state = IDLE;
      end
      
      SETUP: begin
        penable = 1'b0;
        next_state = ACCESS;
      end

      ACCESS: begin
        penable = 1'b1;
        if (pready && transfer)
          next_state = IDLE;
        else if (pready && !transfer)
          next_state = SETUP;
        else
          next_state = ACCESS;
      end
      
      default: next_state = IDLE;
    endcase
  end
  
  assign psel1 = (state != IDLE);
  assign pwrite = ((state == SETUP) || (state == ACCESS)) ? read_write : 1'b0; 
  assign paddr = ((state == SETUP) || (state == ACCESS)) ? apb_read_paddr : 8'b0;
  assign pwdata = (((state == SETUP) || (state == ACCESS)) && read_write) ? apb_write_data : 8'b0;
  assign apb_read_dat_out = (((state == SETUP) || (state == ACCESS)) && !read_write) ? pr_data : 8'b0;

endmodule
