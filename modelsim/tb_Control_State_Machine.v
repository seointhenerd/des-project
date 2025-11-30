`timescale 1ns/1ps

module tb_Control_State_Machine;
    reg clk, rst;
    reg start_encrypt, start_decrypt;
    reg [63:0] key, input_text;
    wire done_encrypt, done_decrypt;
    wire [63:0] output_text;
    
    Control_State_Machine dut (
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
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    integer timeout;
    
    initial begin
        rst = 1;
        start_encrypt = 0;
        start_decrypt = 0;
        key = 0;
        input_text = 0;
        #50;
        rst = 0;
        #50;
        
        $display("\n=== DES Test Vector 1 ===");
        key = 64'h752878397493CB70;
        input_text = 64'h1122334455667788;
        $display("Key:       %h", key);
        $display("Plaintext: %h", input_text);
        $display("Expected:  b5219ee81aa7499d");
        
        start_encrypt = 1;
        #10;
        start_encrypt = 0;
        
        timeout = 0;
        while (!done_encrypt && timeout < 1000) begin
            @(posedge clk);
            timeout = timeout + 1;
        end
        
        $display("Result:    %h %s", output_text, 
                 (output_text == 64'hB5219EE81AA7499D) ? "PASS" : "FAIL");
        
        #100;
        
        $display("\n=== DES Test Vector 2 ===");
        key = 64'h123456ABCD132536;
        input_text = 64'hAABB09182736CCDD;
        $display("Key:       %h", key);
        $display("Plaintext: %h", input_text);
        $display("Expected:  ac85a39bab193fd5");
        
        rst = 1;
        #20;
        rst = 0;
        #20;
        
        start_encrypt = 1;
        #10;
        start_encrypt = 0;
        
        timeout = 0;
        while (!done_encrypt && timeout < 1000) begin
            @(posedge clk);
            timeout = timeout + 1;
        end
        
        $display("Result:    %h %s", output_text,
                 (output_text == 64'hAC85A39BAB193FD5) ? "PASS" : "FAIL");
        
        #100;
        $stop;
    end

endmodule
