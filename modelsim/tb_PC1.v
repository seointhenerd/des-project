`timescale 1ns/1ps
module tb_PC1;
  reg  [1:64] in;
  wire [1:56] out;

  PC1 dut (.in(in), .out(out));

  // Expected output (wired directly by the PC-1 table)
  wire [1:56] exp;
  assign exp[1]  = in[57];
  assign exp[2]  = in[49];
  assign exp[3]  = in[41];
  assign exp[4]  = in[33];
  assign exp[5]  = in[25];
  assign exp[6]  = in[17];
  assign exp[7]  = in[9];
  assign exp[8]  = in[1];
  assign exp[9]  = in[58];
  assign exp[10] = in[50];
  assign exp[11] = in[42];
  assign exp[12] = in[34];
  assign exp[13] = in[26];
  assign exp[14] = in[18];
  assign exp[15] = in[10];
  assign exp[16] = in[2];
  assign exp[17] = in[59];
  assign exp[18] = in[51];
  assign exp[19] = in[43];
  assign exp[20] = in[35];
  assign exp[21] = in[27];
  assign exp[22] = in[19];
  assign exp[23] = in[11];
  assign exp[24] = in[3];
  assign exp[25] = in[60];
  assign exp[26] = in[52];
  assign exp[27] = in[44];
  assign exp[28] = in[36];
  assign exp[29] = in[63];
  assign exp[30] = in[55];
  assign exp[31] = in[47];
  assign exp[32] = in[39];
  assign exp[33] = in[31];
  assign exp[34] = in[23];
  assign exp[35] = in[15];
  assign exp[36] = in[7];
  assign exp[37] = in[62];
  assign exp[38] = in[54];
  assign exp[39] = in[46];
  assign exp[40] = in[38];
  assign exp[41] = in[30];
  assign exp[42] = in[22];
  assign exp[43] = in[14];
  assign exp[44] = in[6];
  assign exp[45] = in[61];
  assign exp[46] = in[53];
  assign exp[47] = in[45];
  assign exp[48] = in[37];
  assign exp[49] = in[29];
  assign exp[50] = in[21];
  assign exp[51] = in[13];
  assign exp[52] = in[5];
  assign exp[53] = in[28];
  assign exp[54] = in[20];
  assign exp[55] = in[12];
  assign exp[56] = in[4];

  initial begin
    // 1) all zeros
    in = {64{1'b0}}; #1; if (out !== exp) begin $display("PC1 fail: zeros"); $fatal(1); end

    // 2) all ones
    in = {64{1'b1}}; #1; if (out !== exp) begin $display("PC1 fail: ones"); $fatal(1); end

    // 3) walking-1
    in = {64{1'b0}}; in[1]  = 1; #1; if (out !== exp) $fatal(1);
    in = {64{1'b0}}; in[32] = 1; #1; if (out !== exp) $fatal(1);
    in = {64{1'b0}}; in[64] = 1; #1; if (out !== exp) $fatal(1);

    // 4) known-ish pattern
    in = 64'h133457799BBCDFF1; #1; if (out !== exp) begin $display("PC1 fail: pattern"); $fatal(1); end

    $display("PC1: all tests PASSED");
    $finish;
  end
endmodule
