module APB_topmodule(
  input pclk,
  input presetn,
  input transfer,
  input read_write,
  input [7:0] apb_write_paddr,
  input [7:0] apb_write_data,
  input [7:0] apb_read_paddr,
  
  output wire[7:0]prdata,
  output wire pready);
  
  wire pwrite;
  wire psel1;
  wire penable;
  wire [7:0] paddr;
  wire [7:0] pwdata;
  wire [7:0] prdata;
  wire [7:0] apb_read_data_out[7:0];
  wire pready;
  
  APB_master dut1 (.pclk(pclk),
                   .presetn(presetn),
                   .transfer(transfer),
                   .read_write(read_write),
                   .apb_write_padd(apb_write_paddr),
                   .apb_write_data(apb_write_data),
                   .apb_read_paddr(apb_read_paddr),
.pready(pready),
.pwrite(pwrite),
.psel1(psel1),
.penable(penable),
.paddr(paddr)
.pwdata(pwdata)
                   .apb_read_data_out(apb_read_data_out));
  
  APB_slave dut2(.pclk(pclk),
                 .presetn(presetn),
                 .psel1(psel1),
                 .penable(penable),
                 .pwrite(pwrite),
                 .paddr(paddr),
                 .pwdata(pwdata),
                 .prdata(prdata),
                 .pready(pready));
  
  assign prdata = apb_read_paddr;
  assign pready = pready;
  
endmodule
