
`timescale 1ns / 1ps

module tb_sbox;
      	reg  [47:0] in;	
      	wire [31:0] out;	

	reg [31:0] expected_out;
      	SBoxArray DUT (.xor_result(in), .sbox_out(out));

      	initial begin
		// test 0
		in = 48'b0;	
		expected_out = 32'b11101111101001110010110001001101;	
          	#10;
          	if (out == expected_out)
              	$display("PASS: Test 0 out = %b", out);
          	else
              	$display("FAIL: Test 0 out = %b", out);

      		// Test case 1: input 000001 for S-box 1, 000000 for others
  		#10
  		in = 48'b000001;
		expected_out = 32'b11101111101001110010110001000001;
            	#10;
            	if (out == expected_out)
                	$display("PASS: Test 1 out = %b", out);
            	else
                	$display("FAIL: Test 1 out = %b", out);

  		// Test case 2: input 000010 for all S-boxes  
  		#10
  		in = 48'b000010_000010_000010_000010_000010_000010_000010_000010;
		expected_out = 32'b01000001000011011100000110110010;
  		#10;
  		if (out == expected_out)
  		    $display("PASS: Test 2 out = %b", out);
  		else
  		    $display("FAIL: Test 2 out = %b (expected 01000001000011011100000110110010)", out);

  		// Test case 3: input 000111 for all S-boxes
  		#10
  		in = 48'b000111_000111_000111_000111_000111_000111_000111_000111;
		expected_out = 32'b01000111100101011100001001111000;
  		#10;
  		if (out == expected_out)
  		    $display("PASS: Test 3 out = %b", out);
  		else
  		    $display("FAIL: Test 3 out = %b (expected 01000111100101011100001001111000)", out);

  		// Test case 4: input 010101 for all S-boxes
  		#10
  		in = 48'b010101_010101_010101_010101_010101_010101_010101_010101;
		expected_out = 32'b11000001010100101111110101010110;
  		#10;
  		if (out == expected_out)
  		    $display("PASS: Test 4 out = %b", out);
  		else
  		    $display("FAIL: Test 4 out = %b (expected 11000001010100101111110101010110)", out);

  		// Test case 5: input 101010 for all S-boxes
  		#10
		expected_out = 32'b01100100111110111101100000111100;
  		in = 48'b101010_101010_101010_101010_101010_101010_101010_101010;
  		#10;
  		if (out == expected_out)
  		    $display("PASS: Test 5 out = %b", out);
  		else
  		    $display("FAIL: Test 5 out = %b (expected 01100100111110111101100000111100)", out);

  		// Test case 6: input 111111 for all S-boxes
  		#10
  		in = 48'b111111_111111_111111_111111_111111_111111_111111_111111;
		expected_out = 32'b11011001110011100011110111001011;
  		#10;
  		if (out == expected_out)
  		    $display("PASS: Test 6 out = %b", out);
  		else
  		    $display("FAIL: Test 6 out = %b (expected 11011001110011100011110111001011 )", out);

        	end
    
  endmodule 
