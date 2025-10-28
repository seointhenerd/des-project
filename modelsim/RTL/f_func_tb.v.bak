`timescale 1ns / 1ps

/*module tb_Feistel_Simple;
      	reg  [31:0] R_in;
      	reg  [47:0] subkey;
      	wire [31:0] f_out;

      	Feistel_Function DUT (.R_in(R_in), .subkey(subkey), .f_out(f_out));

      	initial begin
		// DES Round 1 test
		R_in = 32'hF0AAF0AA;
		subkey = 48'h1B02EFFC7072;
          	#10;
          	if (f_out == 32'h00EF5700)
              	$display("PASS: f_out = %h", f_out);
          	else
              	$display("FAIL: f_out = %h (expected 00EF5700)", f_out);
      	end
  endmodule */

/*
 module tb_Feistel_Diagnostic;

      // Test inputs
      reg  [31:0] R_in;
      reg  [47:0] subkey;

      // Intermediate signals
      wire [47:0] expanded;
      wire [47:0] xor_result;
      wire [31:0] sbox_result;
      wire [31:0] pbox_result;

      // Known correct values for DES Round 1
      // R0 = 0xF0AAF0AA, K1 = 0x1B02EFFC7072
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

          // Test case: DES Round 1
          R_in   = 32'hF0AAF0AA;
          subkey = 48'h1B02EFFC7072;

          // Expected values (calculated from DES specification)
          // E(R0) with R0 = 0xF0AAF0AA
          expected_expansion = 48'h7A15557A1555;
          // E(R0) XOR K1
          expected_xor = 48'h6117ba866527;
          // After S-boxes (need to calculate)
          expected_sbox = 32'h234AA9BB;
          // After P-box
          expected_final = 32'h00EF5700;

          #10; // Wait for combinational logic to settle

          $display("Input Values:");
          $display("  R_in   = %h", R_in);
          $display("  subkey = %h\n", subkey);

          // ================================================================
          // Stage 1: Test Expansion
          // ================================================================
          $display("Stage 1: Expansion (32 -> 48 bits)");
          $display("  Input:    R_in = %h", R_in);
          $display("  Output:   E(R) = %h", expanded);
          $display("  Expected: E(R) = %h", expected_expansion);

          if (expanded == expected_expansion) begin
              $display("  PASS: Expansion correct\n");
          end else begin
              $display("  FAIL: Expansion incorrect!");
              $display("  Let's check bit-by-bit:");
              $display("  R_in bits: %b", R_in);
              $display("  E(R) got:  %b", expanded);
              $display("  E(R) exp:  %b\n", expected_expansion);
          end

          // ================================================================
          // Stage 2: Test XOR
          // ================================================================
          $display("Stage 2: XOR with subkey");
          $display("  E(R)      = %h", expanded);
          $display("  subkey    = %h", subkey);
          $display("  XOR result= %h", xor_result);
          $display("  Expected  = %h", expected_xor);

          if (xor_result == expected_xor) begin
              $display("  PASS: XOR correct\n");
          end else begin
              $display("  FAIL: XOR incorrect!");
              $display("  Manual check: %h XOR %h = %h\n",
                       expanded, subkey, expanded ^ subkey);
          end

          // ================================================================
          // Stage 3: Test S-box Array
          // ================================================================
          $display("Stage 3: S-box Array (48 -> 32 bits)");
          $display("  Input:  xor_result = %h", xor_result);
          $display("  Output: sbox_out   = %h", sbox_result);
          $display("  Expected (verify): = %h\n", expected_sbox);

          // Break down by individual S-boxes
          $display("  Individual S-box inputs and outputs:");
          $display("    S1: input=%b (%h), output=?", xor_result[47:42], xor_result[47:42]);
          $display("    S2: input=%b (%h), output=?", xor_result[41:36], xor_result[41:36]);
          $display("    S3: input=%b (%h), output=?", xor_result[35:30], xor_result[35:30]);
          $display("    S4: input=%b (%h), output=?", xor_result[29:24], xor_result[29:24]);
          $display("    S5: input=%b (%h), output=?", xor_result[23:18], xor_result[23:18]);
          $display("    S6: input=%b (%h), output=?", xor_result[17:12], xor_result[17:12]);
          $display("    S7: input=%b (%h), output=?", xor_result[11:6],  xor_result[11:6]);
          $display("    S8: input=%b (%h), output=?", xor_result[5:0],   xor_result[5:0]);
          $display("    Combined sbox_out = %h\n", sbox_result);

          // ================================================================
          // Stage 4: Test P-box
          // ================================================================
          $display("Stage 4: P-box (32 -> 32 bits permutation)");
          $display("  Input:  sbox_result = %h", sbox_result);
          $display("  Output: pbox_out    = %h", pbox_result);
          $display("  Expected final      = %h", expected_final);

          if (pbox_result == expected_final) begin
              $display("  PASS: P-box and overall function correct\n");
          end else begin
              $display("  FAIL: P-box output incorrect!\n");
          end

          // ================================================================
          // Summary
          // ================================================================
          $display("========================================");
          $display("Final Result:");
          $display("  Got:      %h", pbox_result);
          $display("  Expected: %h", expected_final);
          if (pbox_result == expected_final)
              $display("  OVERALL PASS");
          else
              $display("  OVERALL FAIL");
          $display("========================================\n");

      end

  endmodule  */

/*
 module tb_SBox_Verify;

      reg  [5:0] s_in;
      reg  [2:0] box_num;
      wire [3:0] s_out;

      SBox DUT (.s_in(s_in), .box_num(box_num), .s_out(s_out));

      initial begin
          $display("S-box Individual Verification");
          $display("Testing with DES Round 1 values\n");

          // From diagnostic: xor_result = 6117ba866527
          // Breaking into 6-bit chunks:

          // S1: input = 011000 (0x18)
          // Row = {0,0} = 0, Col = 1100 = 12
          // S1[row=0, col=12] should be 5
          box_num = 3'd0;
          s_in = 6'b011000;
          #10;
          $display("S1: input=%b, row=%d, col=%d, output=%h (expected: 5)",
                   s_in, {s_in[5],s_in[0]}, s_in[4:1], s_out);

          // S2: input = 010001 (0x11)
          // Row = {0,1} = 1, Col = 1000 = 8
          // S2[row=1, col=8] should be 12 (0xC)
          box_num = 3'd1;
          s_in = 6'b010001;
          #10;
          $display("S2: input=%b, row=%d, col=%d, output=%h (expected: c)",
                   s_in, {s_in[5],s_in[0]}, s_in[4:1], s_out);

          // S3: input = 011110 (0x1e)
          // Row = {0,0} = 0, Col = 1111 = 15
          // S3[row=0, col=15] should be 8
          box_num = 3'd2;
          s_in = 6'b011110;
          #10;
          $display("S3: input=%b, row=%d, col=%d, output=%h (expected: 8)",
                   s_in, {s_in[5],s_in[0]}, s_in[4:1], s_out);

          // S4: input = 111010 (0x3a)
          // Row = {1,0} = 2, Col = 1101 = 13
          // S4[row=2, col=13] should be 2
          box_num = 3'd3;
          s_in = 6'b111010;
          #10;
          $display("S4: input=%b, row=%d, col=%d, output=%h (expected: 2)",
                   s_in, {s_in[5],s_in[0]}, s_in[4:1], s_out);

          // S5: input = 100001 (0x21)
          // Row = {1,1} = 3, Col = 0000 = 0
          // S5[row=3, col=0] should be 11 (0xB)
          box_num = 3'd4;
          s_in = 6'b100001;
          #10;
          $display("S5: input=%b, row=%d, col=%d, output=%h (expected: b)",
                   s_in, {s_in[5],s_in[0]}, s_in[4:1], s_out);

          // S6: input = 100110 (0x26)
          // Row = {1,0} = 2, Col = 0011 = 3
          // S6[row=2, col=3] should be 5
          box_num = 3'd5;
          s_in = 6'b100110;
          #10;
          $display("S6: input=%b, row=%d, col=%d, output=%h (expected: 5)",
                   s_in, {s_in[5],s_in[0]}, s_in[4:1], s_out);

          // S7: input = 010100 (0x14)
          // Row = {0,0} = 0, Col = 1010 = 10
          // S7[row=0, col=10] should be 9
          box_num = 3'd6;
          s_in = 6'b010100;
          #10;
          $display("S7: input=%b, row=%d, col=%d, output=%h (expected: 9)",
                   s_in, {s_in[5],s_in[0]}, s_in[4:1], s_out);

          // S8: input = 100111 (0x27)
          // Row = {1,1} = 3, Col = 0011 = 3
          // S8[row=3, col=3] should be 7
          box_num = 3'd7;
          s_in = 6'b100111;
          #10;
          $display("S8: input=%b, row=%d, col=%d, output=%h (expected: 7)",
                   s_in, {s_in[5],s_in[0]}, s_in[4:1], s_out);

          $display("\nExpected combined S-box output: 5c82b597");
          $display("If all individual S-boxes are correct, the problem is in P-box");

      end

  endmodule */



 module tb_Feistel_Zero_Test;

      reg  [31:0] R_in;
      reg  [47:0] subkey;

      wire [47:0] expanded;
      wire [47:0] xor_result;
      wire [31:0] sbox_result;
      wire [31:0] pbox_result;

      // Instantiate modules
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
          $display("DES Zero Test - Round 1");
          $display("Plaintext: 0x0000000000000000");
          $display("Key:       0x0000000000000000");
          $display("========================================\n");

          // All-zero test
          // Plaintext = 0, Key = 0
          // After IP: L0 = 0, R0 = 0
          // Round 1 subkey K1 = 0 (for zero key)

          R_in   = 32'h00000000;
          subkey = 48'h000000000000;

          #10;

          $display("Round 1 Inputs:");
          $display("  R0 = %h", R_in);
          $display("  K1 = %h\n", subkey);

          $display("Pipeline Stages:");
          $display("  1. Expansion:   %h (%b)", expanded, expanded);
          $display("  2. XOR result:  %h (%b)", xor_result, xor_result);
          $display("  3. S-box out:   %h (%b)", sbox_result, sbox_result);
          $display("  4. P-box out:   %h (%b)", pbox_result, pbox_result);

          $display("\n========================================");
          $display("Expected from DES specification:");
          $display("  Expansion of 0x00000000 = 0x000000000000");
          $display("  XOR with 0x000000000000 = 0x000000000000");

          // When all S-box inputs are 000000 (all zeros)
          // Each S-box row=00 (bits 5,0), col=0000 (bits 4,1)
          // S1[0,0]=14, S2[0,0]=15, S3[0,0]=10, S4[0,0]=7
          // S5[0,0]=2,  S6[0,0]=12, S7[0,0]=4,  S8[0,0]=13
          $display("  S-box output should be:  EFA72C4D");
          $display("  (S1=14, S2=15, S3=10, S4=7, S5=2, S6=12, S7=4, S8=13)");

          if (sbox_result == 32'hEFA72C4D) begin
              $display("  PASS: S-box output correct!");
          end else begin
              $display("  FAIL: S-box output = %h (expected EFA72C4D)", sbox_result);
          end

          $display("========================================\n");

      end

  endmodule