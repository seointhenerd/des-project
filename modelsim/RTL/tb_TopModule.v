`timescale 1ns/1ps

module tb_TopModule;
    reg clk, rst, sclk, cs_n, mosi;
    wire miso;
    reg [63:0] key, plaintext, ciphertext, decrypted;
    integer timeout_counter;
    
    TopModule dut (
        .clk(clk),
        .rst(rst),
        .sclk(sclk),
        .cs_n(cs_n),
        .mosi(mosi),
        .miso(miso)
    );
    
    // Clock
    initial clk = 0; 
    always #5 clk = ~clk;
    
    initial sclk = 0; 
    always #50 sclk = ~sclk;

    //SPI write
    task spi_write_64(input [63:0] data);
        integer i;
        begin
            cs_n = 1;
            mosi = 0;
            #200;
            
            @(negedge sclk);
            #10;
            mosi = data[63];
            #10;
            cs_n = 0;
            
            for (i = 62; i >= 0; i = i - 1) begin
                @(posedge sclk);
                #10;
                @(negedge sclk);
                mosi = data[i];
                #10;
            end
            
            @(posedge sclk);
            #10;
            @(negedge sclk);
            #10;
            cs_n = 1;
            mosi = 0;
            
            repeat(20) @(posedge clk);
            #200;
        end
    endtask
    
    // SPI read
    task spi_read_64(output [63:0] data);
        integer i;
        reg [63:0] tmp;
        begin
            tmp = 64'h0;
            cs_n = 1;
            mosi = 0;
            #200;
            
            @(negedge sclk);
            #10;
            cs_n = 0;
            #10;
            
            @(posedge sclk);
            #10;
            tmp[63] = miso;
            
            for (i = 62; i >= 0; i = i - 1) begin
                @(posedge sclk);
                #10;
                tmp[i] = miso;
            end
            
            @(negedge sclk);
            #10;
            cs_n = 1;
            data = tmp;
            
            repeat(20) @(posedge clk);
            #200;
        end
    endtask
    
    initial begin
        
        // Initialize
        rst = 1;
        cs_n = 1;
        mosi = 0;
        #100;
        rst = 0;
        #100;
        
        key       = 64'h752878397493CB70;
        plaintext = 64'h1122334455667788;
        
        $display("=== ENCRYPTION TEST ===");
        $display("Key:       %h", key);
        $display("Plaintext: %h", plaintext);
        $display("Expected:  b5219ee81aa7499d");
        
        // send KEY, DATA, CONTROL
        spi_write_64(key);
        spi_write_64(plaintext);
        spi_write_64(64'h0000000000000000);  // encrypt
        
        // encryption progress
        $display("\n encryption progress");
        timeout_counter = 0;
        while (!dut.done_encrypt_latched && timeout_counter < 5000) begin
            @(posedge clk);
            timeout_counter = timeout_counter + 1;
        end
        if (timeout_counter >= 5000) begin
            $display("timeout");
            $stop;
        end
        
        // Read result
        spi_read_64(ciphertext);
        
        $display("\n--- ENCRYPTION RESULT ---");
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   b5219ee81aa7499d");
        
        if (ciphertext == 64'hB5219EE81AA7499D) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        
        #1000;
        
        $display("=== DECRYPTION TEST ===");
        $display("Key:        %h", key);
        $display("Ciphertext: %h", ciphertext);
        
        // send KEY, DATA, CONTROL
        spi_write_64(key);
        spi_write_64(ciphertext);
        spi_write_64(64'h0000000000000001);  // decrypt
        
        // decryption progress
        $display("\n decryption progress");
        timeout_counter = 0;
        while (!dut.done_decrypt_latched && timeout_counter < 5000) begin
            @(posedge clk);
            timeout_counter = timeout_counter + 1;
        end
        if (timeout_counter >= 5000) begin
            $display("timeout");
            $stop;
        end
        
        // Read result
        spi_read_64(decrypted);
        
        $display("\n--- DECRYPTION RESULT ---");
        $display("Decrypted:  %h", decrypted);
        $display("Expected:   %h", plaintext);
        
        if (decrypted == plaintext) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end

        $display("============");
        
        if (ciphertext == 64'hB5219EE81AA7499D && decrypted == plaintext) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("SOME TESTS FAILED");
        end
        #1000;
        $stop;
    end
    
    initial begin
        #200000;
        $display("\nERROR: Global timeout");
        $stop;
    end
    
endmodule
