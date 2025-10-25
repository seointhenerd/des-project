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
          expected_xor = 48'h6117A8866427;
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

  endmodule