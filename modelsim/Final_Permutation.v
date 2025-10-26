module Final_Permutation (
  input wire [31:0] left_half,
  input wire [31:0] right_half,
  output reg [63:0] output_text
);

    // DES IP^-1 (Inverse IP) table
    localparam [6:0] FP_table [0:63] = '{
        40, 8, 48, 16, 56, 24, 64, 32,
        39, 7, 47, 15, 55, 23, 63, 31,
        38, 6, 46, 14, 54, 22, 62, 30,
        37, 5, 45, 13, 53, 21, 61, 29,
        36, 4, 44, 12, 52, 20, 60, 28,
        35, 3, 43, 11, 51, 19, 59, 27,
        34, 2, 42, 10, 50, 18, 58, 26,
        33, 1, 41, 9,  49, 17, 57, 25
    };
    
    reg [63:0] combined;
    integer i;

    always @(left_half, right_half) begin
	combined[63:32]= left_half;
	combined[31:0]= right_half;
	for (i=0; i<64; i=i+1) begin
		output_text[i]=combined[FP_table[i] -1];
	end
    end

endmodule
