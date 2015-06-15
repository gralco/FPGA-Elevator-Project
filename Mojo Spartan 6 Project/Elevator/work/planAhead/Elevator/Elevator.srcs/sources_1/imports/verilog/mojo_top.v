module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from rst button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard leds
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
    input en,
    input [3:0] F,
    output [3:0] D,
    output [3:0] Q,
    output A,
    output B,
    output A_latch,
    output B_latch
    );

wire rst = ~rst_n; // make rst active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

reg [24:0] slow_clk_d, slow_clk_q;

always @(slow_clk_q) begin
  slow_clk_d = slow_clk_q + 1'b1;
end

always @(posedge clk, posedge rst) begin
    if (rst == 1) begin
        slow_clk_q <= 25'b0;
    end
    else begin
        slow_clk_q <= slow_clk_d;
    end
end

assign led[7:4] = {4{slow_clk_q[24]}};

elevator real_deal (
    .clk(slow_clk_q[24]),
    .reset(rst),
    .en(en),
    .F(F),
    .D(D),
    .Q(Q),
    .A(A),
    .B(B),
    .A_latch(A_latch),
    .B_latch(B_latch),
    .LED(led[3:0])
);

endmodule