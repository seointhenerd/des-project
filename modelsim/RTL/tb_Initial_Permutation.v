`timescale 1ns / 1ps

module tb_Initial_Permutation;

    reg [63:0] input_text;
    wire [31:0] left_half;
    wire [31:0] right_half;
    
    integer error_count;
    integer i;
    
    reg [31:0] expected_left;
    reg [31:0] expected_right;
    
    Initial_Permutation DUT (
        .input_text(input_text),
        .left_half(left_half),
        .right_half(right_half)
    );

endmodule
