module spi_slave (
    input CS,
    input SCLK,
    input MOSI,
    input [7:0] data_in,
    output reg MISO,
    output reg [7:0] data_out
);
    reg [7:0] tx_shift_reg, rx_shift_reg;
    reg [2:0] bit_cnt;

    always @(negedge CS) begin
        tx_shift_reg <= data_in;
        bit_cnt <= 3'd7;
    end

    always @(posedge SCLK) begin
        if (!CS) begin
            rx_shift_reg[bit_cnt] <= MOSI;
        end
    end

    always @(negedge SCLK) begin
        if (!CS) begin
            MISO <= tx_shift_reg[bit_cnt];
            if (bit_cnt == 0)
                data_out <= rx_shift_reg;
            else
                bit_cnt <= bit_cnt - 1;
        end
    end
endmodule

