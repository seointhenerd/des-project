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
        
        // TEST CASE 1
        rst = 1;
        cs_n = 1;
        mosi = 0;
        #100;
        rst = 0;
        #100;
        
        key       = 64'h752878397493CB70;
        plaintext = 64'h1122334455667788;
        
        $display("=== ENCRYPTION TEST 1 : Default test vector ===");
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
        
        $display("\n=== DECRYPTION TEST ===");
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


        // TEST CASE 2
        rst = 1;
        cs_n = 1;
        mosi = 0;
        #100;
        rst = 0;
        #100;
        
        key       = 64'h123456ABCD132536;
        plaintext = 64'hAABB09182736CCDD;
        
        $display("\n=== ENCRYPTION TEST 2 : Default test vector ===");
        $display("Key:       %h", key);
        $display("Plaintext: %h", plaintext);
        $display("Expected:  c0b7a8d05f3a829c");
        
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
        $display("Expected:   ac85a39bab193fd5");
        
        if (ciphertext == 64'hac85a39bab193fd5) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        
        #1000;
        
        $display("\n=== DECRYPTION TEST ===");
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

	// TEST CASE 3
        rst = 1;
        cs_n = 1;
        mosi = 0;
        #100;
        rst = 0;
        #100;
        
        key       = 64'b0;
        plaintext = 64'b0;
        
        $display("\n=== ENCRYPTION TEST 3 : All zeros ===");
        $display("Key:       %h", key);
        $display("Plaintext: %h", plaintext);
        $display("Expected:  8ca64de9c1b123a7");
        
        // send KEY, DATA, CONTROL
        spi_write_64(key);
        spi_write_64(plaintext);
        spi_write_64(64'h0000000000000000);  // encrypt
        
        // encryption progress
        $display("\n encryption progress");
        // Read result
        spi_read_64(ciphertext);
        
        $display("\n--- ENCRYPTION RESULT ---");
        $display("Ciphertext: %h", ciphertext);
        $display("Expected:   8ca64de9c1b123a7");
        
        if (ciphertext == 64'h8ca64de9c1b123a7) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        
        #1000;
        
        $display("\n=== DECRYPTION TEST ===");
        $display("Key:        %h", key);
        $display("Ciphertext: %h", ciphertext);
        
        // send KEY, DATA, CONTROL
        spi_write_64(key);
        spi_write_64(ciphertext);
        spi_write_64(64'h0000000000000001);  // decrypt
        
        // decryption progress
        $display("\n decryption progress");
        
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

	// TEST CASE 4
        rst = 1;
        cs_n = 1;
        mosi = 0;
        #100;
        rst = 0;
        #100;
        
        key       = 64'hffffffffffffffff;
        plaintext = 64'hffffffffffffffff;
        
        $display("\n=== ENCRYPTION TEST 4 : All fs ===");
        $display("Key:       %h", key);
        $display("Plaintext: %h", plaintext);
        $display("Expected:  7359b2163e4edc58");
        
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
        $display("Expected:   7359b2163e4edc58");
        
        if (ciphertext == 64'h7359b2163e4edc58) begin
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

	// TEST CASE 5 - reset
        rst = 1;
        cs_n = 1;
        mosi = 0;
        #1000;
        rst = 0;
        #1000;

	// TEST CASE 6
        $display("\n=== ENCRYPTION TEST 6 : Sending data while encrypting/decrypting ===");
        $display("Key:       %h", key);
        $display("Plaintext: %h", plaintext);
        $display("Expected:  c0b7a8d05f3a829c");
        
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
        $display("Expected:   ac85a39bab193fd5");
        
        if (ciphertext == 64'hac85a39bab193fd5) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        
        #1000;
        
        $display("\n=== DECRYPTION TEST ===");
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
	$stop;
    end

endmodule
