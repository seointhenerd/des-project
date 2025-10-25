`timescale 1ns/1ps
module right_reg_tb;
  // inputs
  reg         clk;
  reg         rst;         // active-low
  reg         en;
  reg         load_init;
  reg  [31:0] R_0;
  reg  [31:0] R_in;

  // output
  wire [31:0] R_curr;

  right_reg #(.WIDTH(32)) dut (
    .clk      (clk),
    .rst      (rst),
    .en       (en),
    .load_init(load_init),
    .R_0      (R_0),
    .R_in     (R_in),
    .R_curr   (R_curr)
  );

  // clock
  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  initial begin
    // defaults
    en = 0;
    load_init = 0;
    R_0  = 32'h0000_0000;
    R_in = 32'h0000_0000;

    // assert active-low reset
    rst = 0;
    #20;

    // deassert reset
    rst = 1;
    #10;

    // load initial R0
    R_0 = 32'h1234_5678;
    load_init = 1;
    #15;
    load_init = 0;
    #30;

    // step a few rounds (en=1): R_curr <= R_in
    en = 1;
    R_in = 32'hDEAD_BEEF; #20;
    R_in = 32'hCAFEBABE;  #20;
    R_in = 32'h0ACE_FACE; #20;

    // hold (en=0): R must not change even if R_in does
    en = 0;
    R_in = 32'hABCD_EF01; #20;
    R_in = 32'h1357_9BDF; #20;

    // simultaneous load_init and en: load_init has priority
    R_0 = 32'h1111_2222;
    en = 1;
    load_init = 1; #15;
    load_init = 0; #30;

    // async reset in the middle of activity
    #7; rst = 0;  // assert
    #10; rst = 1; // release
    #20;

    // load after reset to recover state
    R_0 = 32'hFEDC_BA98;
    load_init = 1; #15;
    load_init = 0; #30;

    // one more round
    en = 1;
    R_in = 32'h0F0F_F0F0; #20;

    $stop;
  end
endmodule
