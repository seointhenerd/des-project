module Initial_Permutation (
    input  wire [63:0] input_text,
    output reg  [31:0] left_half,
    output reg  [31:0] right_half
);

    localparam [6:0] IP_table [0:63] = '{
        58, 50, 42, 34, 26, 18, 10, 2,
        60, 52, 44, 36, 28, 20, 12, 4,
        62, 54, 46, 38, 30, 22, 14, 6,
        64, 56, 48, 40, 32, 24, 16, 8,
        57, 49, 41, 33, 25, 17, 9,  1,
        59, 51, 43, 35, 27, 19, 11, 3,
        61, 53, 45, 37, 29, 21, 13, 5,
        63, 55, 47, 39, 31, 23, 15, 7
    };

    reg [63:0] permuted_data;
    integer i;

    always @(*) begin
        for (i = 0; i < 64; i = i + 1) begin
            permuted_data[i] = input_text[IP_table[i] - 1];
        end
        left_half  = permuted_data[63:32];
        right_half = permuted_data[31:0];
    end

endmodule