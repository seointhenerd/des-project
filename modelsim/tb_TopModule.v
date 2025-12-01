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
    
    // Clocks
    initial clk = 0; 
    always #5 clk = ~clk;
    
    initial sclk = 0; 
    always #50 sclk = ~sclk;

    // SPI write
    task spi_write_64(input [63:0] data);
        integer i;
        begin
            @(negedge sclk);
            mosi = data[63];
            cs_n = 0;
            @(posedge sclk);
            
            for (i = 62; i >= 0; i = i - 1) begin
                @(negedge sclk);
                mosi = data[i];
                @(posedge sclk);
            end
            
            @(negedge sclk);
            cs_n = 1;
            mosi = 0;
            repeat(20) @(posedge clk);
        end
    endtask
    
    // SPI read
    task spi_read_64(output [63:0] data);
        integer i;
        reg [63:0] tmp;
        begin
            tmp = 64'h0;
            @(negedge sclk);
            mosi = 0;
            cs_n = 0;
            
            @(posedge sclk);
            #2;
            tmp[63] = miso;
            
            for (i = 62; i >= 0; i = i - 1) begin
                @(negedge sclk);
                mosi = 0;
                @(posedge sclk);
                #2;
                tmp[i] = miso;
            end
            
            @(negedge sclk);
            cs_n = 1;
            data = tmp;
            repeat(20) @(posedge clk);
        end
    endtask
    
    // Wait for operation with timeout
    task wait_operation(input integer max_cycles);
        integer i;
        begin
            for (i = 0; i < max_cycles; i = i + 1) begin
                @(posedge clk);
            end
        end
    endtask
    
    initial begin
        // TEST CASE 1
        rst = 1;
        cs_n = 1;
        mosi = 0;
        #100;
        rst = 0;
        #100;
        
        key       = 64'h752878397493CB70;
        plaintext = 64'h1122334455667788;
        
        $display("\n=== ENCRYPTION TEST 1: Default test vector ===");
        $display("Key:       %h", key);
        $display("Plaintext: %h", plaintext);
        $display("Expected:  b5219ee81aa7499d");
        
        spi_write_64(key);
        spi_write_64(plaintext);
        spi_write_64(64'h0000000000000000);  // encrypt
        
        $display("Encryption in progress...");
        wait_operation(5000);  // Wait fixed time instead of checking internal signal
        
        spi_read_64(ciphertext);
        
        $display("\n--- ENCRYPTION RESULT ---");
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   b5219ee81aa7499d");
        
        if (ciphertext == 64'hB5219EE81AA7499D) begin
            $display(">>> PASS <<<");
        end else begin
            $display(">>> FAIL <<<");
        end
        
        #1000;
        
        $display("\n=== DECRYPTION TEST 1 ===");
        $display("Key:        %h", key);
        $display("Ciphertext: %h", ciphertext);
        
        spi_write_64(key);
        spi_write_64(ciphertext);
        spi_write_64(64'h0000000000000001);  // decrypt
        
        $display("Decryption in progress...");
        wait_operation(5000);
        
        spi_read_64(decrypted);
        
        $display("\n--- DECRYPTION RESULT ---");
        $display("Decrypted:  %h", decrypted);
        $display("Expected:   %h", plaintext);
        
        if (decrypted == plaintext) begin
            $display(">>> PASS <<<");
        end else begin
            $display(">>> FAIL <<<");
        end

        // TEST CASE 2
        #1000;
        rst = 1;
        #100;
        rst = 0;
        #100;
        
        key       = 64'h123456ABCD132536;
        plaintext = 64'hAABB09182736CCDD;
        
        $display("\n=== ENCRYPTION TEST 2: Custom test vector ===");
        $display("Key:       %h", key);
        $display("Plaintext: %h", plaintext);
        $display("Expected:  ac85a39bab193fd5");
        
        spi_write_64(key);
        spi_write_64(plaintext);
        spi_write_64(64'h0000000000000000);
        
        $display("Encryption in progress...");
        wait_operation(5000);
        
        spi_read_64(ciphertext);
        
        $display("\n--- ENCRYPTION RESULT ---");
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   ac85a39bab193fd5");
        
        if (ciphertext == 64'hac85a39bab193fd5) begin
            $display(">>> PASS <<<");
        end else begin
            $display(">>> FAIL <<<");
        end
        
        #1000;
        
        $display("\n=== DECRYPTION TEST 2 ===");
        spi_write_64(key);
        spi_write_64(ciphertext);
        spi_write_64(64'h0000000000000001);
        
        wait_operation(5000);
        spi_read_64(decrypted);
        
        $display("\n--- DECRYPTION RESULT ---");
        $display("Decrypted:  %h", decrypted);
        $display("Expected:   %h", plaintext);
        
        if (decrypted == plaintext) begin
            $display(">>> PASS <<<");
        end else begin
            $display(">>> FAIL <<<");
        end

        // TEST CASE 3
        #1000;
        rst = 1;
        #100;
        rst = 0;
        #100;
        
        key       = 64'b0;
        plaintext = 64'b0;
        
        $display("\n=== ENCRYPTION TEST 3: All zeros ===");
        $display("Key:       %h", key);
        $display("Plaintext: %h", plaintext);
        $display("Expected:  8ca64de9c1b123a7");
        
        spi_write_64(key);
        spi_write_64(plaintext);
        spi_write_64(64'h0000000000000000);
        
        wait_operation(5000);
        spi_read_64(ciphertext);
        
        $display("\n--- ENCRYPTION RESULT ---");
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   8ca64de9c1b123a7");
        
        if (ciphertext == 64'h8ca64de9c1b123a7) begin
            $display(">>> PASS <<<");
        end else begin
            $display(">>> FAIL <<<");
        end
        
        #1000;
        
        $display("\n=== DECRYPTION TEST 3 ===");
        spi_write_64(key);
        spi_write_64(ciphertext);
        spi_write_64(64'h0000000000000001);
        
        wait_operation(5000);
        spi_read_64(decrypted);
        
        $display("\n--- DECRYPTION RESULT ---");
        $display("Decrypted:  %h", decrypted);
        $display("Expected:   %h", plaintext);
        
        if (decrypted == plaintext) begin
            $display(">>> PASS <<<");
        end else begin
            $display(">>> FAIL <<<");
        end

        // TEST CASE 4
        #1000;
        rst = 1;
        #100;
        rst = 0;
        #100;
        
        key       = 64'hffffffffffffffff;
        plaintext = 64'hffffffffffffffff;
        
        $display("\n=== ENCRYPTION TEST 4: All ones ===");
        $display("Key:       %h", key);
        $display("Plaintext: %h", plaintext);
        $display("Expected:  7359b2163e4edc58");
        
        spi_write_64(key);
        spi_write_64(plaintext);
        spi_write_64(64'h0000000000000000);
        
        wait_operation(5000);
        spi_read_64(ciphertext);
        
        $display("\n--- ENCRYPTION RESULT ---");
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   7359b2163e4edc58");
        
        if (ciphertext == 64'h7359b2163e4edc58) begin
            $display(">>> PASS <<<");
        end else begin
            $display(">>> FAIL <<<");
        end
        
        #1000;
        
        $display("\n=== DECRYPTION TEST 4 ===");
        spi_write_64(key);
        spi_write_64(ciphertext);
        spi_write_64(64'h0000000000000001);
        
        wait_operation(5000);
        spi_read_64(decrypted);
        
        $display("\n--- DECRYPTION RESULT ---");
        $display("Decrypted:  %h", decrypted);
        $display("Expected:   %h", plaintext);
        
        if (decrypted == plaintext) begin
            $display(">>> PASS <<<");
        end else begin
            $display(">>> FAIL <<<");
        end

        #1000;
        
        $display("\n============================================");
        $display("       ALL TESTS COMPLETE");
        $display("============================================\n");
        $stop;
    end

endmodule