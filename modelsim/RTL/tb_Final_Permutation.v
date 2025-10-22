`timescale 1ns / 1ps

module tb_Final_Permutation;

    reg [31:0] left_half;
    reg [31:0] right_half;
    wire [63:0] output_text;
    integer error_count;
    
    Final_Permutation DUT (
        .left_half(left_half),
        .right_half(right_half),
        .output_text(output_text)
    );

endmodule
