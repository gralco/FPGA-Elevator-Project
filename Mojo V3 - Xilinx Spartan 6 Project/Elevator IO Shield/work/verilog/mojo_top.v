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
    output [23:0] io_led, // LEDs on IO Shield
    output [7:0] io_seg, // 7-segment LEDs on IO Shield
    output [3:0] io_sel, // Digit select on IO Shield
    input [3:0] F,
    input en,
    input [23:0] io_dip,
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

reg [26:0] slow_clk_d, slow_clk_q;

always @(slow_clk_q) begin
  if (~io_dip[23] & ~io_dip[22]) begin
      slow_clk_d = slow_clk_q + 2'b1;
  end else if (io_dip[23] & ~io_dip[22]) begin
      slow_clk_d = slow_clk_q + 2'b10;
  end else if (~io_dip[23] & io_dip[22]) begin
      slow_clk_d = slow_clk_q + 3'b100;
  end else begin
      slow_clk_d = slow_clk_q + 4'b1000;
  end
end

always @(posedge clk, posedge rst) begin
    if (rst == 1) begin
        slow_clk_q <= 27'b0;
    end
    else begin
        slow_clk_q <= slow_clk_d;
    end
end

assign led[7:4] = {4{slow_clk_q[26]}};
assign io_led[23:0] = {24{slow_clk_q[26]}};

assign io_sel[3:0] = 4'b0000;

elevator real_deal (
    .clk(slow_clk_q[26]),
    .reset(rst),
    .en(~en),
    .F(F),
    .D(D),
    .Q(Q),
    .A(A),
    .B(B),
    .A_latch(A_latch),
    .B_latch(B_latch),
    .LED(led[3:0]),
    .io_seg(io_seg)
);

endmodule