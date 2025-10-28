
`timescale 1ns / 1ps

module tb_sbox;
      	reg  [47:0] in;	
      	wire [31:0] out;	

      	SBoxArray DUT (.xor_result(in), .sbox_out(out));

      	initial begin
		in = 48'b0;		
          	#10;
          	if (out == 32'b11101111101001110010110001001101)
              	$display("PASS: out = %b", out);
          	else
              	$display("FAIL: out = %b", out);

		#10
		in = 48'b000001;		
          	#10;
          	if (out == 32'b0	0	0	0	0	0	1	1	1	1	0	1	1	1	0	1	1	1	1	0	1	0	1	0	1	1	0	1	0	0	0	1)
              	$display("PASS: out = %b", out);
          	else
              	$display("FAIL: out = %b", out)

      	end
  endmodule 