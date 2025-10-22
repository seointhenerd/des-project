module Control_State_Machine (
  input wire clk,
  input wire rst,
  input wire start_encrypt,
  input wire start_decrypt,
  input wire mode,
  input wire [63:0] key,
  input wire [63:0] input_text,

  output wire done_encrypt,
  output wire done_decrypt,
  output wire [63:0] output_text,
  output wire subkey_req,
  output wire [4:0] round_counter
);

    INTERNAL SIGNALS:
        state               // Current FSM state
        left_reg[32]        // Left register
        right_reg[32]       // Right register
        round_output[32]    // Output from round function
        
    STATES:
        IDLE                // Waiting for start signal
        INIT_PERM           // Initial Permutation
        ROUND_PROCESS       // Processing 16 rounds
        FINAL_PERM          // Final Permutation
        DONE                // Output result
    
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
