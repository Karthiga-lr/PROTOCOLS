module spi_master (
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    input MISO,
    output reg [7:0] data_out,
    output reg MOSI,
    output reg SCLK,
    output reg CS,
    output reg done
);
    reg [2:0] bit_cnt;
    reg [7:0] tx_shift_reg, rx_shift_reg;
    reg [1:0] state;

    parameter IDLE = 2'd0, LOAD = 2'd1, SAMPLE = 2'd2, DONE = 2'd3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            SCLK <= 0;
            CS <= 1;
            MOSI <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    SCLK <= 0;
                    CS <= 1;
                    done <= 0;
                    if (start) begin
                        tx_shift_reg <= data_in;
                        rx_shift_reg <= 8'd0;
                        bit_cnt <= 3'd7;
                        CS <= 0;
                        state <= LOAD;
                    end
                end

                LOAD: begin
                    MOSI <= tx_shift_reg[bit_cnt];
                    SCLK <= 1;  // Rising edge
                    state <= SAMPLE;
                end

                SAMPLE: begin
                    rx_shift_reg[bit_cnt] <= MISO;  // Sample on rising edge
                    SCLK <= 0;  // Falling edge
                    if (bit_cnt == 0)
                        state <= DONE;
                    else begin
                        bit_cnt <= bit_cnt - 1;
                        state <= LOAD;
                    end
                end

                DONE: begin
                    CS <= 1;
                    done <= 1;
                    data_out <= rx_shift_reg;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
