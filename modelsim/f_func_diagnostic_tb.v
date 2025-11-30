
`timescale 1ns / 1ps

module tb_Feistel_Internal;

      // Test inputs
      reg  [31:0] R_in;
      reg  [47:0] subkey;

      // Intermediate signals
      wire [47:0] expanded;
      wire [47:0] xor_result;
      wire [31:0] sbox_result;
      wire [31:0] pbox_result;

      // Known correct values for DES Round 1
      // R0 = xxxx, K1 = yyyy
      reg [47:0] expected_expansion;
      reg [47:0] expected_xor;
      reg [31:0] expected_sbox;
      reg [31:0] expected_final;

      // Instantiate each module separately
      Expansion exp_test (
          .R_in(R_in),
          .E_out(expanded)
      );

      assign xor_result = expanded ^ subkey;

      SBoxArray sbox_test (
          .xor_result(xor_result),
          .sbox_out(sbox_result)
      );

      PBox pbox_test (
          .p_in(sbox_result),
          .p_out(pbox_result)
      );

      initial begin
          $display("========================================");
          $display("Feistel Function Diagnostic Test");
          $display("========================================\n");


 	// Test case: DES Round 2
 	$display("\n========================================");
  	$display("Test Case: DES Round 2");
 	$display("========================================\n");

 	R_in   = 32'b0101_0011_1001_1010_0010_1001_0001_0101;
  	subkey = 48'b0101_0100_0111_1110_1110_1110_0100_1101_0100_0100_0011_1100;

  	// Expected values from CSV Round 2
 	expected_expansion = 48'b1111_1110_0000_0010_0001_1010_0101_1000_0110_1100_1001_0110;
 	expected_xor = 48'b1111_1110_0000_0010_0001_1010_0101_1000_0110_1100_1001_0110;
  	expected_sbox = 32'b1101_0000_0110_1100_1111_1111_1111_1110;
  	expected_final = 32'b0011_1011_1011_0111_1011_0100_1110_1111;

  #10; // Wait for combinational logic to settle

  $display("Input Values:");
  $display("  R_in   = %b", R_in);
  $display("  subkey = %b\n", subkey);

  // Stage 1: Expansion
  $display("Stage 1: Expansion");
  $display("  Output:   E(R) = %b", expanded);
  $display("  Expected: E(R) = %b", expected_expansion);
  if (expanded == expected_expansion)
      $display("  PASS: Expansion correct\n");
  else
      $display("  FAIL: Expansion incorrect\n");

  // Stage 2: XOR
  $display("Stage 2: XOR with subkey");
  $display("  XOR result= %b", xor_result);
  $display("  Expected  = %b", expected_xor);
  if (xor_result == expected_xor)
      $display("  PASS: XOR correct\n");
  else
      $display("  FAIL: XOR incorrect\n");

  // Stage 3: S-box
  $display("Stage 3: S-box Array");
  $display("  Output: sbox_out = %b", sbox_result);
  $display("  Expected:        = %b", expected_sbox);
  if (sbox_result == expected_sbox)
      $display("  PASS: S-box correct\n");
  else
      $display("  FAIL: S-box incorrect\n");

  // Stage 4: P-box
  $display("Stage 4: P-box");
  $display("  Output:   pbox_out = %b", pbox_result);
  $display("  Expected: final   = %b", expected_final);
  if (pbox_result == expected_final)
      $display("  PASS: P-box correct\n");
  else
      $display("  FAIL: P-box incorrect\n");

  $display("Final Result for Round 2:");
  if (pbox_result == expected_final)
      $display("  OVERALL PASS\n");
  else
      $display("  OVERALL FAIL\n");
                


end
endmodule
