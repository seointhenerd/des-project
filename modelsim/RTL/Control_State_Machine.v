module Control_State_Machine (
    input  wire clk,
    input  wire rst,
    input  wire start_encrypt,
    input  wire start_decrypt,
    input  wire [63:0] key,
    input  wire [63:0] input_text,
    
    output reg done_encrypt,
    output reg done_decrypt,
    output reg [63:0] output_text
);

    // State definitions
    localparam IDLE         = 3'b000;
    localparam INIT_PERM    = 3'b001;
    localparam ROUND_PROCESS = 3'b010;
    localparam FINAL_PERM   = 3'b011;
    localparam DONE         = 3'b100;
    
    reg [2:0] state;
    reg [3:0] round_counter;
    reg mode;  // 0=encrypt, 1=decrypt
    
    // Registers
    reg [31:0] left_reg, right_reg;
    
    // Wires connecting to other modules
    wire [31:0] ip_left, ip_right;
    wire [47:0] expanded_right;
    wire [47:0] current_subkey;
    wire [47:0] xor_with_key;
    wire [31:0] sbox_output;
    wire [31:0] new_right;
    wire [63:0] fp_output;
    
    // Module instantiations based on block diagram
    // Initial Permutation
    Initial_Permutation ip_inst (
        .input_text(input_text),
        .left_half(ip_left),
        .right_half(ip_right)
    );
    
    // Expansion (32 bits -> 48 bits) :  variables have to be modified
    Expansion expansion_inst (
        .input_32b(right_reg),
        .output_48b(expanded_right)
    );
    
    // XOR with subkey
    assign xor_with_key = expanded_right ^ current_subkey;
    
    // S-boxes (48 bits -> 32 bits) :  variables have to be modified
    S_Boxes sboxes_inst (
        .input_48b(xor_with_key),
        .output_32b(sbox_output)
    );
    
    // XOR with left half
    assign new_right = left_reg ^ sbox_output;
    
    // Subkey Generator : variables have to be modified
    Subkey_Generator keygen_inst (
        .key(key),
        .round_num(round_counter),
        .mode(mode),
        .subkey(current_subkey)
    );
    
    // Final Permutation
    Final_Permutation fp_inst (
        .left_half(left_reg),
        .right_half(right_reg),
        .output_text(fp_output)
    );
    PROCESS:
        ON RESET:
            state = IDLE
            round_counter = 0
            done_encrypt = 0
            done_decrypt = 0
            left_reg = 0
            right_reg = 0
            
        ON CLOCK:
            CASE state OF
            
                IDLE:
                    done_encrypt = 0
                    done_decrypt = 0
                    round_counter = 0
                    
                    IF (start_encrypt OR start_decrypt) THEN
                        state = INIT_PERM
                    END IF
                
                INIT_PERM:
                    // Apply Initial Permutation
                    (left_reg, right_reg) = Initial_Permutation(input_text)
                    round_counter = 0
                    state = ROUND_PROCESS
                    
                ROUND_PROCESS:
                    // Request appropriate subkey
                    IF mode == ENCRYPT THEN
                        subkey_index = round_counter
                    ELSE  // DECRYPT
                        subkey_index = 15 - round_counter
                    END IF
                    
                    // Perform Feistel round
                    // temp = right_reg
                    // right_reg = left_reg XOR f(right_reg, subkey[round_counter])
                    // left_reg = temp
                    
                    temp[32] = right_reg
                    round_output = Feistel_Function(right_reg, subkey[subkey_index])
                    right_reg = left_reg XOR round_output
                    left_reg = temp
                    
                    round_counter = round_counter + 1
                    
                    IF round_counter == 16 THEN
                        state = FINAL_PERM
                    END IF
                    
                FINAL_PERM:
                    // Apply Final Permutation (with swap)
                    output_text = Final_Permutation(left_reg, right_reg)
                    state = DONE
                    
                DONE:
                    IF mode == ENCRYPT THEN
                        done_encrypt = 1
                    ELSE
                        done_decrypt = 1
                    END IF
                    
                    // Wait for acknowledgment
                    IF (NOT start_encrypt AND NOT start_decrypt) THEN
                        state = IDLE
                    END IF
                    
            END CASE
            
endmodule
