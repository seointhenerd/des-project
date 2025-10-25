`timescale 1ns/1ps
module tb_PC1;
  reg  [1:64] in;
  wire [1:56] out;
  reg  [1:56] exp;

  PC1 dut (.in(in), .out(out));

  task check(input [1:64] vin, input [1023:0] tag);
    begin
      in = vin; #2;
      if (out !== exp) begin
        $display("[FAIL] PC1 %0s", tag);
        $display("  in = 0x%016h", in);
        $display("  exp= 0x%014h", exp);
        $display("  out= 0x%014h", out);
        $fatal(1);
      end else
        $display("[PASS] PC1 %0s", tag);
    end
  endtask

  initial begin
    // 1) all zeros -> zeros
    exp = {56{1'b0}};
    check({64{1'b0}}, "zeros");
    #10;

    // 2) all ones -> ones (parity bits dropped but all remaining are 1)
    exp = {56{1'b1}};
    check({64{1'b1}}, "ones");
    #10;

    // 3) single 1 at in[1] -> out[8] (from PC1 table)
    exp = {56{1'b0}}; exp[8]  = 1'b1;
    in  = {64{1'b0}}; in[1]   = 1'b1;  check(in, "in[1] -> out[8]");
    #10;

    // 4) single 1 at in[57] -> out[1]
    exp = {56{1'b0}}; exp[1]  = 1'b1;
    in  = {64{1'b0}}; in[57]  = 1'b1;  check(in, "in[57] -> out[1]");
    #10;

    // 5) single 1 at in[28] -> out[53]
    exp = {56{1'b0}}; exp[53] = 1'b1;
    in  = {64{1'b0}}; in[28]  = 1'b1;  check(in, "in[28] -> out[53]");
    #10;

    // 6) single 1 at in[64] (parity) -> dropped -> zeros
    exp = {56{1'b0}};
    in  = {64{1'b0}}; in[64]  = 1'b1;  check(in, "in[64] dropped");
    #10;

    $display("PC1 TB: all tests passed.");
    $stop;
  end
endmodule
