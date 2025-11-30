// -----------------------------------------------------------------------------
// DES key-schedule left rotate for a 28-bit [1:28] bus (bit1 = MSB).
// Rounds 1,2,9,16 -> shift by 1; all others -> shift by 2.
// Pure combinational: no functions, no for-loops in always blocks.
// -----------------------------------------------------------------------------
module left_shift(
  input  wire [5:1]  round,     // 1..16
  input  wire [28:1] in28,      // [1]=MSB, [28]=LSB
  output wire [28:1] out28
);
  // Precompute rotate-by-1
  wire [28:1] rot1;
  genvar i1;
  generate
    for (i1 = 1; i1 <= 27; i1 = i1 + 1) begin : GEN_ROT1
      assign rot1[i1] = in28[i1+1];
    end
  endgenerate
  assign rot1[28] = in28[1];

  // Precompute rotate-by-2
  wire [28:1] rot2;
  genvar i2;
  generate
    for (i2 = 1; i2 <= 26; i2 = i2 + 1) begin : GEN_ROT2
      assign rot2[i2] = in28[i2+2];
    end
  endgenerate
  assign rot2[27] = in28[1];
  assign rot2[28] = in28[2];

  // Select shift amount by round
  wire shift1 = (round==5'd1)  | (round==5'd2) |
                (round==5'd9)  | (round==5'd16);

  // Final output
  assign out28 = shift1 ? rot1 : rot2;

endmodule
