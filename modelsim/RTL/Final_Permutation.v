module Final_Permutation (
    input  wire [31:0] left_half,
    input  wire [31:0] right_half,
    output reg  [63:0] output_text
);

    // DES IP^-1 (Inverse Initial Permutation) table as synthesizable constant
    localparam [6:0] FP_table [0:63] = '{
        7'd40, 7'd8,  7'd48, 7'd16, 7'd56, 7'd24, 7'd64, 7'd32,
        7'd39, 7'd7,  7'd47, 7'd15, 7'd55, 7'd23, 7'd63, 7'd31,
        7'd38, 7'd6,  7'd46, 7'd14, 7'd54, 7'd22, 7'd62, 7'd30,
        7'd37, 7'd5,  7'd45, 7'd13, 7'd53, 7'd21, 7'd61, 7'd29,
        7'd36, 7'd4,  7'd44, 7'd12, 7'd52, 7'd20, 7'd60, 7'd28,
        7'd35, 7'd3,  7'd43, 7'd11, 7'd51, 7'd19, 7'd59, 7'd27,
        7'd34, 7'd2,  7'd42, 7'd10, 7'd50, 7'd18, 7'd58, 7'd26,
        7'd33, 7'd1,  7'd41, 7'd9,  7'd49, 7'd17, 7'd57, 7'd25
    };

    reg [63:0] combined;
    integer i;

    always @(*) begin
        combined[63:32] = left_half;
        combined[31:0]  = right_half;
        for (i = 0; i < 64; i = i + 1) begin
            output_text[i] = combined[FP_table[i] - 1];
        end
    end

endmodule


