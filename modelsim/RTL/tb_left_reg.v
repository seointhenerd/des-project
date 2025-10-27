`timescale 1ns/1ps
module tb_left_reg;
  // inputs
  reg         clk;
  reg         rst;        // active-low
  reg         en;
  reg         load_init;
  reg  [31:0] L_0;
  reg  [31:0] R_prev;

  // output
  wire [31:0] L_curr;

  left_reg #(.WIDTH(32)) dut (
    .clk      (clk),
    .rst      (rst),
    .en       (en),
    .load_init(load_init),
    .L_0      (L_0),
    .R_prev   (R_prev),
    .L_curr   (L_curr)
  );

  // clock
  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  initial begin
    // init
    en = 0;
    load_init = 0;
    L_0 = 32'h0000_0000;
    R_prev = 32'h0000_0000;

    // assert active-low reset
    rst = 0;
    #20;

    // deassert reset
    rst = 1;
    #10;

    // load initial L0
    L_0 = 32'hAAAA_5555;
    load_init = 1;
    #15;
    load_init = 0;
    #30;

    // step a few rounds (en=1): L <= R_prev
    en = 1;
    R_prev = 32'hDEAD_BEEF; #20;
    R_prev = 32'hCAFE_BABE; #20;
    R_prev = 32'h0123_4567; #20;

    // hold (en=0): L must not change even if R_prev does
    en = 0;
    R_prev = 32'h89AB_CDEF; #20;
    R_prev = 32'h1357_9BDF; #20;

    // simultaneous load_init and en: load_init has priority
    L_0 = 32'h1111_2222;
    en = 1;
    load_init = 1; #15;
    load_init = 0; #30;

    // async reset in the middle of activity
    #7; rst = 0;  // assert
    #10; rst = 1; // release
    #20;

    // load after reset to recover state
    L_0 = 32'hFEDC_BA98;
    load_init = 1; #15;
    load_init = 0; #30;

    // one more round
    en = 1;
    R_prev = 32'h0F0F_F0F0; #20;

    $stop;
  end
endmodule
