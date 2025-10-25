// -----------------------------------------------------------------------------
// DES Key Schedule (parallel K1..K16) ? Verilog-2001 friendly, simple wiring
// - key      : [64:1] (bit 1 = MSB)
// - k1..k16  : [48:1]
// Requires: PC1, PC2, left_shift (with .round, .in28, .out28)
// -----------------------------------------------------------------------------
module key_schedule(
  input  wire [64:1] key,
  output wire [48:1] k1,
  output wire [48:1] k2,
  output wire [48:1] k3,
  output wire [48:1] k4,
  output wire [48:1] k5,
  output wire [48:1] k6,
  output wire [48:1] k7,
  output wire [48:1] k8,
  output wire [48:1] k9,
  output wire [48:1] k10,
  output wire [48:1] k11,
  output wire [48:1] k12,
  output wire [48:1] k13,
  output wire [48:1] k14,
  output wire [48:1] k15,
  output wire [48:1] k16
);
  // Map key [64:1] (descending) -> [1:64] (ascending) for PC1
  wire [1:64] key_asc;
  genvar gi;
  generate
    for (gi=1; gi<=64; gi=gi+1) begin : MAP_KEY_TO_ASC
      assign key_asc[gi] = key[65-gi];
    end
  endgenerate

  // PC-1: 64 -> 56 (ascending)
  wire [1:56] key_pc1;
  PC1 pc1_inst(.in(key_asc), .out(key_pc1));

  // Split into C0, D0 (each [28:1])
  wire [28:1] C0, D0;
  generate
    for (gi=1; gi<=28; gi=gi+1) begin : SPLIT_PC1
      assign C0[gi] = key_pc1[gi];
      assign D0[gi] = key_pc1[28+gi];
    end
  endgenerate

  // Round rotates: C0/D0 -> C1/D1 -> ... -> C16/D16
  wire [28:1] C1,  D1;
  wire [28:1] C2,  D2;
  wire [28:1] C3,  D3;
  wire [28:1] C4,  D4;
  wire [28:1] C5,  D5;
  wire [28:1] C6,  D6;
  wire [28:1] C7,  D7;
  wire [28:1] C8,  D8;
  wire [28:1] C9,  D9;
  wire [28:1] C10, D10;
  wire [28:1] C11, D11;
  wire [28:1] C12, D12;
  wire [28:1] C13, D13;
  wire [28:1] C14, D14;
  wire [28:1] C15, D15;
  wire [28:1] C16, D16;

  // Use constants for round input (1,2,9,16 shift by 1; others by 2)
  left_shift ls_c1  (.round(5'd1 ), .in28(C0 ), .out28(C1 ));
  left_shift ls_d1  (.round(5'd1 ), .in28(D0 ), .out28(D1 ));
  left_shift ls_c2  (.round(5'd2 ), .in28(C1 ), .out28(C2 ));
  left_shift ls_d2  (.round(5'd2 ), .in28(D1 ), .out28(D2 ));
  left_shift ls_c3  (.round(5'd3 ), .in28(C2 ), .out28(C3 ));
  left_shift ls_d3  (.round(5'd3 ), .in28(D2 ), .out28(D3 ));
  left_shift ls_c4  (.round(5'd4 ), .in28(C3 ), .out28(C4 ));
  left_shift ls_d4  (.round(5'd4 ), .in28(D3 ), .out28(D4 ));
  left_shift ls_c5  (.round(5'd5 ), .in28(C4 ), .out28(C5 ));
  left_shift ls_d5  (.round(5'd5 ), .in28(D4 ), .out28(D5 ));
  left_shift ls_c6  (.round(5'd6 ), .in28(C5 ), .out28(C6 ));
  left_shift ls_d6  (.round(5'd6 ), .in28(D5 ), .out28(D6 ));
  left_shift ls_c7  (.round(5'd7 ), .in28(C6 ), .out28(C7 ));
  left_shift ls_d7  (.round(5'd7 ), .in28(D6 ), .out28(D7 ));
  left_shift ls_c8  (.round(5'd8 ), .in28(C7 ), .out28(C8 ));
  left_shift ls_d8  (.round(5'd8 ), .in28(D7 ), .out28(D8 ));
  left_shift ls_c9  (.round(5'd9 ), .in28(C8 ), .out28(C9 ));
  left_shift ls_d9  (.round(5'd9 ), .in28(D8 ), .out28(D9 ));
  left_shift ls_c10 (.round(5'd10), .in28(C9 ), .out28(C10));
  left_shift ls_d10 (.round(5'd10), .in28(D9 ), .out28(D10));
  left_shift ls_c11 (.round(5'd11), .in28(C10), .out28(C11));
  left_shift ls_d11 (.round(5'd11), .in28(D10), .out28(D11));
  left_shift ls_c12 (.round(5'd12), .in28(C11), .out28(C12));
  left_shift ls_d12 (.round(5'd12), .in28(D11), .out28(D12));
  left_shift ls_c13 (.round(5'd13), .in28(C12), .out28(C13));
  left_shift ls_d13 (.round(5'd13), .in28(D12), .out28(D13));
  left_shift ls_c14 (.round(5'd14), .in28(C13), .out28(C14));
  left_shift ls_d14 (.round(5'd14), .in28(D13), .out28(D14));
  left_shift ls_c15 (.round(5'd15), .in28(C14), .out28(C15));
  left_shift ls_d15 (.round(5'd15), .in28(D14), .out28(D15));
  left_shift ls_c16 (.round(5'd16), .in28(C15), .out28(C16));
  left_shift ls_d16 (.round(5'd16), .in28(D15), .out28(D16));

  // For each round i, build cd_i = {Ci, Di} as [1:56], then PC2 -> Ki
  wire [1:56] cd1,  cd2,  cd3,  cd4,  cd5,  cd6,  cd7,  cd8;
  wire [1:56] cd9,  cd10, cd11, cd12, cd13, cd14, cd15, cd16;

  // pack helper
  genvar p;
  generate
    for (p=1; p<=28; p=p+1) begin : PACK_CD
      assign cd1[p]       = C1[p];   assign cd1[28+p]  = D1[p];
      assign cd2[p]       = C2[p];   assign cd2[28+p]  = D2[p];
      assign cd3[p]       = C3[p];   assign cd3[28+p]  = D3[p];
      assign cd4[p]       = C4[p];   assign cd4[28+p]  = D4[p];
      assign cd5[p]       = C5[p];   assign cd5[28+p]  = D5[p];
      assign cd6[p]       = C6[p];   assign cd6[28+p]  = D6[p];
      assign cd7[p]       = C7[p];   assign cd7[28+p]  = D7[p];
      assign cd8[p]       = C8[p];   assign cd8[28+p]  = D8[p];
      assign cd9[p]       = C9[p];   assign cd9[28+p]  = D9[p];
      assign cd10[p]      = C10[p];  assign cd10[28+p] = D10[p];
      assign cd11[p]      = C11[p];  assign cd11[28+p] = D11[p];
      assign cd12[p]      = C12[p];  assign cd12[28+p] = D12[p];
      assign cd13[p]      = C13[p];  assign cd13[28+p] = D13[p];
      assign cd14[p]      = C14[p];  assign cd14[28+p] = D14[p];
      assign cd15[p]      = C15[p];  assign cd15[28+p] = D15[p];
      assign cd16[p]      = C16[p];  assign cd16[28+p] = D16[p];
    end
  endgenerate

  // PC-2 for each round
  PC2 pc2_1  (.in(cd1 ),  .out(k1 ));
  PC2 pc2_2  (.in(cd2 ),  .out(k2 ));
  PC2 pc2_3  (.in(cd3 ),  .out(k3 ));
  PC2 pc2_4  (.in(cd4 ),  .out(k4 ));
  PC2 pc2_5  (.in(cd5 ),  .out(k5 ));
  PC2 pc2_6  (.in(cd6 ),  .out(k6 ));
  PC2 pc2_7  (.in(cd7 ),  .out(k7 ));
  PC2 pc2_8  (.in(cd8 ),  .out(k8 ));
  PC2 pc2_9  (.in(cd9 ),  .out(k9 ));
  PC2 pc2_10 (.in(cd10),  .out(k10));
  PC2 pc2_11 (.in(cd11),  .out(k11));
  PC2 pc2_12 (.in(cd12),  .out(k12));
  PC2 pc2_13 (.in(cd13),  .out(k13));
  PC2 pc2_14 (.in(cd14),  .out(k14));
  PC2 pc2_15 (.in(cd15),  .out(k15));
  PC2 pc2_16 (.in(cd16),  .out(k16));

endmodule
