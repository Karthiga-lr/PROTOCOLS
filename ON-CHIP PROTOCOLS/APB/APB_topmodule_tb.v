module APB_topmodule_tb;

  reg        pclk;
  reg        presetn;
  reg        transfer;
  reg        read_write;
  reg [7:0]  apb_read_add;
  reg [7:0]  apb_write_add;
  reg [7:0]  apb_write_data;

  wire [7:0] prdata;
  wire       pready;

  // Instantiate the DUT
  APB_topmodule dut (
    .pclk(pclk),
    .presetn(presetn),
    .transfer(transfer),
    .read_write(read_write),
    .apb_read_paddr(apb_read_add),
    .apb_write_paddr(apb_write_add),
    .apb_write_data(apb_write_data),
    .prdata(prdata),           // correct wire name
    .pready(pready)
  );

  // Clock generation
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk;
  end

  // Test sequence
  initial begin
    // Dump waveform
    $dumpfile("dump.vcd");
    $dumpvars(0, APB_topmodule_tb);

    // Reset phase
    presetn = 0;
    transfer = 0;
    read_write = 0;
    apb_read_add = 8'd0;
    apb_write_add = 8'd0;
    apb_write_data = 8'd0;

    #10 presetn = 1;
    
    #10;
    transfer = 1;
    read_write = 1; // write
    apb_write_add = 8'h10;
    apb_read_add  = 8'h10;
    apb_write_data = 8'hA5;

    #20;
    transfer = 0;

    #20;
    transfer = 1;
    read_write = 0; // read
    apb_write_add = 8'h10;
    apb_read_add = 8'h10;

    #20;
    transfer = 0;

    #50;
    $finish; 
  end

endmodule
