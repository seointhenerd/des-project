`timescale 1ns / 1ps

module tb_Feistel_Simple;
      	reg  [31:0] R_in;
      	reg  [47:0] subkey;
      	wire [31:0] f_out;
	
	reg [31:0] expected_out;

      	Feistel_Function DUT (.R_in(R_in), .subkey(subkey), .f_out(f_out));

      	initial begin
		#5

		// DES Round 0 test
 		$display("\n========================================");
  		$display("Test Case: DES Round 0");
 		$display("========================================\n");
		R_in = 32'b1000_0000_0110_0110_1000_0000_0110_0110;
		subkey = 48'b0011_1000_1010_1100_1110_1111_0100_0110_0101_0110_0100_1010;
		expected_out = 32'b0100_1011_0111_1101_1101_0011_1000_0010;
          	#10;
          	if (f_out == expected_out)
              	$display("PASS: f_out = %h", f_out);
          	else
              	$display("FAIL: f_out = %h", f_out);

		#10
		// DES Round 1 test
 		$display("\n========================================");
  		$display("Test Case: DES Round 1");
 		$display("========================================\n");
		R_in = 32'b0011_0011_0010_1000_1010_1011_1101_0111;
		subkey = 48'b1000_1001_1011_1110_1101_0100_0100_1000_1001_1101_0001_0010;
		expected_out = 32'b1101_0011_1111_1100_1010_1001_0111_0011;
          	#10;
          	if (f_out == expected_out)
              	$display("PASS: f_out = %h", f_out);
          	else
              	$display("FAIL: f_out = %h", f_out);


		#10
		// DES Round 2 test
 		$display("\n========================================");
  		$display("Test Case: DES Round 2");
 		$display("========================================\n");
		R_in = 32'b0101_0011_1001_1010_0010_1001_0001_0101;
		subkey = 48'b0101_0100_0111_1110_1110_1110_0100_1101_0100_0100_0011_1100;
		expected_out = 32'b0011_1011_1011_0111_1011_0100_1110_1111; 
          	#10;
          	if (f_out == expected_out)
              	$display("PASS: f_out = %h", f_out);
          	else
              	$display("FAIL: f_out = %h", f_out);


		  #10
  		// DES Round 3 test
   		$display("\n========================================");
    		$display("Test Case: DES Round 3");
   		$display("========================================\n");
  		R_in = 32'b0000_1000_1001_1111_0001_1111_0011_1000;
  		subkey = 48'b1111_0010_1111_0101_0110_0000_0100_1001_0101_1000_1100_1000;
  		expected_out = 32'b1100_1000_0100_1111_1111_1111_1111_1100;
            	#10;
            	if (f_out == expected_out)
                	$display("PASS: f_out = %h", f_out);
            	else
                	$display("FAIL: f_out = %h", f_out);


  		#10
  		// DES Round 4 test
   		$display("\n========================================");
    		$display("Test Case: DES Round 4");
   		$display("========================================\n");
  		R_in = 32'b0;
  		subkey = 48'b0;
  		expected_out = 32'b1101_1000_1101_1000_1101_1011_1011_1100;
            	#10;
            	if (f_out == expected_out)
                	$display("PASS: f_out = %h", f_out);
            	else
                	$display("FAIL: f_out = %h", f_out);

		#10
  		// DES Round 5 test
   		$display("\n========================================");
    		$display("Test Case: DES Round 5");
   		$display("========================================\n");
  		R_in = 32'hffff_ffff_ffff_ffff;
  		subkey = 48'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
  		expected_out = 32'b11011000110110001101101110111100;
            	#10;
            	if (f_out == expected_out)
                	$display("PASS: f_out = %h", f_out);
            	else
                	$display("FAIL: f_out = %h", f_out);


		#10
  		// DES Round 6 test
   		$display("\n========================================");
    		$display("Test Case: DES Round 6");
   		$display("========================================\n");
  		R_in = 32'b00000000000000010000000000000000;
  		subkey = 48'b0;
  		expected_out = 32'b11011000100111001101101101111100;
            	#10;
            	if (f_out == expected_out)
                	$display("PASS: f_out = %h", f_out);
            	else
                	$display("FAIL: f_out = %h", f_out);


		#10
  		// DES Round 7 test
   		$display("\n========================================");
    		$display("Test Case: DES Round 7");
   		$display("========================================\n");
  		R_in = 32'b01011100110100111001100001110100;
  		subkey = 48'b111010101011110111000010110110001100111011111011;
  		expected_out = 32'b01010000001000001110100110110010;
            	#10;
            	if (f_out == expected_out)
                	$display("PASS: f_out = %h", f_out);
            	else
                	$display("FAIL: f_out = %h", f_out);

		
	$stop;



      	end
  endmodule

