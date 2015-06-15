module tb_elevator;

reg clk;
reg reset;
reg en;
reg [3:0] F;
wire [3:0] D;
wire [3:0] Q;
wire A;
wire B;
wire A_latch;
wire B_latch;
wire [3:0] LED;

initial begin
    $from_myhdl(
        clk,
        reset,
        en,
        F
    );
    $to_myhdl(
        D,
        Q,
        A,
        B,
        A_latch,
        B_latch,
        LED
    );
end

elevator dut(
    clk,
    reset,
    en,
    F,
    D,
    Q,
    A,
    B,
    A_latch,
    B_latch,
    LED
);

endmodule
