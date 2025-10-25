`timescale 1ns/1ps
module tb_PC2;
  reg  [1:56] in;
  wire [1:48] out;
  reg  [1:48] exp;

  PC2 dut (.in(in), .out(out));

  task check(input [1:56] vin, input [1023:0] tag);
    begin
      in = vin; #2;
      if (out !== exp) begin
        $display("[FAIL] PC2 %0s", tag);
        $display("  in = 0x%014h", in);
        $display("  exp= 0x%012h", exp);
        $display("  out= 0x%012h", out);
        $fatal(1);
      end else
        $display("[PASS] PC2 %0s", tag);
    end
  endtask

  initial begin
    // 1) zeros -> zeros
    exp = {48{1'b0}};
    check({56{1'b0}}, "zeros");
    #10;

    // 2) ones -> ones
    exp = {48{1'b1}};
    check({56{1'b1}}, "ones");
    #10;

    // 3) single-bit spot checks from PC2 table
    // in[14] -> out[1]
    exp = {48{1'b0}}; exp[1]  = 1'b1;
    in  = {56{1'b0}}; in[14]  = 1'b1; check(in, "in[14] -> out[1]");
    #10;

    // in[56] -> out[40]
    exp = {48{1'b0}}; exp[40] = 1'b1;
    in  = {56{1'b0}}; in[56]  = 1'b1; check(in, "in[56] -> out[40]");
    #10;

    // in[32] -> out[48]
    exp = {48{1'b0}}; exp[48] = 1'b1;
    in  = {56{1'b0}}; in[32]  = 1'b1; check(in, "in[32] -> out[48]");
    #10;

    // in[1] -> out[5]
    exp = {48{1'b0}}; exp[5]  = 1'b1;
    in  = {56{1'b0}}; in[1]   = 1'b1; check(in, "in[1] -> out[5]");
    #10;

    // in[28] -> out[8]
    exp = {48{1'b0}}; exp[8]  = 1'b1;
    in  = {56{1'b0}}; in[28]  = 1'b1; check(in, "in[28] -> out[8]");
    #10;

    $display("PC2 TB: all tests passed.");
    $stop;
  end
endmodule
