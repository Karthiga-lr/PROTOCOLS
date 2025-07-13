module spi_tb;
  reg clk;
  reg rst;
  reg start;
  reg [7:0] master_data_in;
  wire [7:0] master_data_out;
  wire MOSI, MISO, SCLK, CS;
  wire done;

  reg [7:0] slave_data_in;
  wire [7:0] slave_data_out;

  // Clock generation
  always #5 clk = ~clk;  // 100MHz clock

  // Instantiate Master
  spi_master master (
    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(master_data_in),
    .data_out(master_data_out),
    .MISO(MISO),
    .MOSI(MOSI),
    .SCLK(SCLK),
    .CS(CS),
    .done(done)
  );

  // Instantiate Slave
  spi_slave slave (
    .CS(CS),
    .SCLK(SCLK),
    .MOSI(MOSI),
    .MISO(MISO),
    .data_in(slave_data_in),
    .data_out(slave_data_out)
  );

  initial begin
    // Initialize
    clk = 0;
    rst = 1;
    start = 0;
    master_data_in = 8'b10101010;
    slave_data_in  = 8'b11001100;
    #20;

    rst = 0;
    #20;
 
    start = 1;
    #10;
    start = 0;
    wait (done == 1);
    $display("Master Sent    = %b", master_data_in);
    $display("Slave Received = %b", slave_data_out);
    $display("Slave Sent     = %b", slave_data_in);
    $display("Master Received= %b", master_data_out);

    #20;
    $finish;
  end
endmodule
          

