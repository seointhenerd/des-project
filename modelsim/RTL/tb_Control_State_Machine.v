`timescale 1ns / 1ps

module tb_Control_State_Machine;

    reg clk;
    reg rst;
    reg start_encrypt;
    reg start_decrypt;
    reg mode;  // 0=encrypt, 1=decrypt
    reg [63:0] key;
    reg [63:0] input_text;
    
    wire done_encrypt;
    wire done_decrypt;
    wire [63:0] output_text;
    wire [3:0] round_counter;
    wire [47:0] current_subkey;
    
    integer i, error_count, cycle_count;

endmodule
