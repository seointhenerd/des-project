`timescale 1ns/1ps
module tb_PC2;
  reg  [1:56] in;
  wire [1:48] out;

  PC2 dut (.in(in), .out(out));

  // Expected per PC-2 table
  wire [1:48] exp;
  assign exp[1]  = in[14];
  assign exp[2]  = in[17];
  assign exp[3]  = in[11];
  assign exp[4]  = in[24];
  assign exp[5]  = in[1];
  assign exp[6]  = in[5];
  assign exp[7]  = in[3];
  assign exp[8]  = in[28];
  assign exp[9]  = in[15];
  assign exp[10] = in[6];
  assign exp[11] = in[21];
  assign exp[12] = in[10];
  assign exp[13] = in[23];
  assign exp[14] = in[19];
  assign exp[15] = in[12];
  assign exp[16] = in[4];
  assign exp[17] = in[26];
  assign exp[18] = in[8];
  assign exp[19] = in[16];
  assign exp[20] = in[7];
  assign exp[21] = in[27];
  assign exp[22] = in[20];
  assign exp[23] = in[13];
  assign exp[24] = in[2];
  assign exp[25] = in[41];
  assign exp[26] = in[52];
  assign exp[27] = in[31];
  assign exp[28] = in[37];
  assign exp[29] = in[47];
  assign exp[30] = in[55];
  assign exp[31] = in[30];
  assign exp[32] = in[40];
  assign exp[33] = in[51];
  assign exp[34] = in[45];
  assign exp[35] = in[33];
  assign exp[36] = in[48];
  assign exp[37] = in[44];
  assign exp[38] = in[49];
  assign exp[39] = in[39];
  assign exp[40] = in[56];
  assign exp[41] = in[34];
  assign exp[42] = in[53];
  assign exp[43] = in[46];
  assign exp[44] = in[42];
  assign exp[45] = in[50];
  assign exp[46] = in[36];
  assign exp[47] = in[29];
  assign exp[48] = in[32];


  integer i;

  initial begin
    // zeros / ones
    in = {56{1'b0}}; #1; if (out !== exp) begin $display("PC2 fail: zeros"); $fatal(1); end
    in = {56{1'b1}}; #1; if (out !== exp) begin $display("PC2 fail: ones");  $fatal(1); end

    // walking-1
    for (i=1; i<=56; i=i+1) begin
      in = {56{1'b0}}; in[i]=1'b1; #1;
      if (out !== exp) begin
        $display("PC2 fail: walking-1 at bit %0d", i);
        $fatal(1);
      end
    end

    $display("PC2: all tests PASSED");
    $stop;
  end
endmodule
