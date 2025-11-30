`timescale 1ns/1ps
module tb_left_shift;
  reg  [5:1]  round;     // 1..16
  reg  [28:1] in28;      // bit1 = MSB
  wire [28:1] out28;

  left_shift dut (.round(round), .in28(in28), .out28(out28));

  // quick compare helper (no computation of expected)
  task check(input [5:1] r, input [28:1] vin, input [28:1] expected, input [1023:0] tag);
    begin
      round = r; in28 = vin; #2; // settle
      if (out28 !== expected) begin
        $display("[FAIL] %0s  r=%0d  in=%07h  exp=%07h  out=%07h", tag, r, vin, expected, out28);
        $fatal(1);
      end else begin
        $display("[PASS] %0s  r=%0d", tag, r);
      end
    end
  endtask

  initial begin
    // ---------------- SHIFT=1 ----------------
    check(5'd1, 28'h0000000, 28'h0000000, "zeros r=1");
    check(5'd2, 28'hFFFFFFF, 28'hFFFFFFF, "ones r=2");
    check(5'd9, 28'hFFFFFFF, 28'hFFFFFFF, "ones r=9");
    check(5'd1, 28'hAAAAAAA, 28'h5555555, "A's r=1");
    check(5'd2, 28'h1000000, 28'h0800000, "misc r=2");
    check(5'd16, 28'h0000001, 28'h8000000, "misc r=16");
    check(5'd9, 28'h2200000, 28'h1100000, "misc r=9");

    // ---------------- SHIFT=2 ----------------
    check(5'd10, 28'h0000000, 28'h0000000, "zeros r=10");
    check(5'd11, 28'hAAAAAAA, 28'hAAAAAAA, "A's r=11");
    check(5'd3, 28'h4000000, 28'h1000000, "misc r=3");
    check(5'd4, 28'h0000001, 28'h4000000, "misc r=4");
    check(5'd12, 28'hC300000, 28'h30C0000, "misc r=12");

    $display("left_shift TB: all tests passed.");
    $stop;
  end
endmodule
