module APB_slave (
  input        pclk,
  input        presetn,
  input        psel1,
  input        pwrite,
  input        penable,
  input  [7:0] paddr,
  input  [7:0] pwdata,
  output reg       pready,
  output reg [7:0] prdata
);

  reg [7:0] mem [255:0];  // Memory array

  always @(posedge pclk) begin
    if (!presetn) begin         // Active-low reset
      prdata <= 8'h00;
      pready <= 1'b0;
    end else if (psel1 && penable) begin
      pready <= 1'b1;
      if (pwrite)
        mem[paddr] <= pwdata;   // Write data to memory
      else
        prdata <= mem[paddr];   // Read data from memory
    end else begin
      pready <= 1'b0;           // Default when not selected or not enabled
    end
  end

endmodule
