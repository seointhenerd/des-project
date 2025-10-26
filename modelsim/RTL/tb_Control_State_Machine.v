`timescale 1ns / 1ps

module tb_Control_State_Machine;
    reg clk;
    reg rst;
    reg start_encrypt;
    reg start_decrypt;
    reg [63:0] key;
    reg [63:0] input_text;
    
    wire done_encrypt;
    wire done_decrypt;
    wire [63:0] output_text;
    
    integer cycle_count;
    integer error_count;

    reg [63:0] ciphertext;
    reg [63:0] first_result;
    integer max_round;
    integer state_check;
    
    Control_State_Machine DUT (
        .clk(clk),
        .rst(rst),
        .start_encrypt(start_encrypt),
        .start_decrypt(start_decrypt),
        .key(key),
        .input_text(input_text),
        .done_encrypt(done_encrypt),
        .done_decrypt(done_decrypt),
        .output_text(output_text)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        error_count = 0;
        cycle_count = 0;
        rst = 1;
        start_encrypt = 0;
        start_decrypt = 0;
        key = 64'h0;
        input_text = 64'h0;
        ciphertext = 64'h0;
        first_result = 64'h0;
        max_round = 0;
        state_check = 0;
        
        // reset
        #20;
        rst = 0;
        #10;
        
        $display("Reset behavior");
        
        if (done_encrypt == 0 && done_decrypt == 0 && DUT.state == DUT.IDLE) begin
            $display("  PASSED: Reset works correctly");
            $display("  State = IDLE, done signals = 0\n");
        end else begin
            $display("  FAILED: Reset didn't initialize properly\n");
            error_count = error_count + 1;
        end

        $display("Encryption sequence");
        
        input_text = 64'h0123456789ABCDEF;
        key = 64'h133457799BBCDFF1;
        
        $display("  Input:  %h", input_text);
        $display("  Key:    %h", key);
        
        start_encrypt = 1;
        #10;
        start_encrypt = 0;
        
        cycle_count = 0;
        
        while (!done_encrypt && cycle_count < 100) begin
            #10;
            cycle_count = cycle_count + 1;
            
            if (DUT.state == DUT.INIT_PERM) begin
                $display("  [Cycle %2d] State: INIT_PERM", cycle_count);
            end else if (DUT.state == DUT.ROUND_PROCESS) begin
                if (DUT.round_counter == 0 || DUT.round_counter == 5 || 
                    DUT.round_counter == 10 || DUT.round_counter == 15) begin
                    $display("  [Cycle %2d] State: ROUND_PROCESS, Round: %2d", 
                             cycle_count, DUT.round_counter);
                end
            end else if (DUT.state == DUT.FINAL_PERM) begin
                $display("  [Cycle %2d] State: FINAL_PERM", cycle_count);
            end else if (DUT.state == DUT.DONE) begin
                $display("  [Cycle %2d] State: DONE", cycle_count);
            end
        end
        
        if (done_encrypt) begin
            $display("  Encryption completed");
            $display("  Total cycles: %d", cycle_count);
            $display("  Output: %h", output_text);
            
            if (cycle_count >= 18 && cycle_count <= 25) begin
                $display("  Cycle count reasonable\n");
            end else begin
                $display("  Warning: Unexpected cycle count\n");
            end
        end else begin
            $display("  FAILED: Encryption timeout\n");
            error_count = error_count + 1;
        end
        
        ciphertext = output_text;
        
        #30;

        $display("Different test vector");
        
        input_text = 64'h1122334455667788;
        key = 64'h0E329232EA6D0D73;
        
        $display("  Input:  %h", input_text);
        $display("  Key:    %h", key);
        
        start_encrypt = 1;
        #10;
        start_encrypt = 0;
        
        wait (done_encrypt);
        
        $display("  Encryption completed");
        $display("  Output: %h\n", output_text);
        
        #30;
        
        $display("Round counter verification");
        
        input_text = 64'hAAAAAAAAAAAAAAAA;
        key = 64'h5555555555555555;
        
        start_encrypt = 1;
        #10;
        start_encrypt = 0;
        
        max_round = 0;
        
        for (cycle_count = 0; cycle_count < 100; cycle_count = cycle_count + 1) begin
            #10;
            if (DUT.round_counter > max_round) begin
                max_round = DUT.round_counter;
            end
            if (done_encrypt) begin
                cycle_count = 100; // Break
            end
        end
        
        if (max_round == 16 || max_round == 15) begin
            $display("  PASSED: Round counter reached %d\n", max_round);
        end else begin
            $display("  FAILED: Max round = %d\n", max_round);
            error_count = error_count + 1;
        end
        
        #30;
        
        $display("Back-to-back operations");
        
        input_text = 64'h1111111111111111;
        key = 64'h2222222222222222;
        
        start_encrypt = 1;
        #10;
        start_encrypt = 0;
        
        wait (done_encrypt);
        first_result = output_text;
        $display("  First encryption:  %h", first_result);
        
        #20;
        
        input_text = 64'h3333333333333333;
        
        start_encrypt = 1;
        #10;
        start_encrypt = 0;
        
        wait (done_encrypt);
        $display("  Second encryption: %h", output_text);
        
        if (first_result != output_text) begin
            $display("  PASSED: Back-to-back operations work\n");
        end else begin
            $display("  FAILED: Results are identical\n");
            error_count = error_count + 1;
        end
        
        #30;

$display("Decryption sequence");

key = 64'h133457799BBCDFF1;
input_text = ciphertext;
$display("  Input (ciphertext): %h", input_text);
$display("  Key:                %h", key);

start_decrypt = 1;
#10;
start_decrypt = 0;

cycle_count = 0;

while (!done_decrypt && cycle_count < 100) begin
    #10;
    cycle_count = cycle_count + 1;
end

if (done_decrypt) begin
    $display("  Decryption completed");
    $display("  Total cycles: %d", cycle_count);
    $display("  Output: %h", output_text);
    
    if (output_text == 64'h0123456789ABCDEF) begin
        $display("  PASSED: Decrypt(Encrypt(x)) = x");
        $display("  Original:  %h", 64'h0123456789ABCDEF);
        $display("  Decrypted: %h\n", output_text);
    end else begin
        $display("  FAILED: Decryption mismatch");
        $display("  Expected: %h", 64'h0123456789ABCDEF);
        $display("  Got:      %h\n", output_text);
        error_count = error_count + 1;
    end
end else begin
    $display("  FAILED: Decryption timeout\n");
    error_count = error_count + 1;
end

        $display("========================================");
        if (error_count == 0) begin
            $display("ALL TESTS PASSED! ");
        end else begin
            $display("%0d TEST(S) FAILED ", error_count);
        end
        $display("========================================\n");
        
        $stop;
    end


endmodule
