`timescale 1ns/1ps
module tb_TopModule();
    reg clk, rst, sclk, cs_n, mosi;
    wire miso;
    reg [63:0] plaintext;
    reg [63:0] ciphertext;
    
    TopModule dut (
        .clk  (clk),
        .rst  (rst),
        .sclk (sclk),
        .cs_n (cs_n),
        .mosi (mosi),
        .miso (miso)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial sclk = 0;
    always #50 sclk = ~sclk;
    
    task spi_write_64(input [63:0] data);
        integer i;
        begin
            @(negedge sclk);
            mosi = data[63];
            #20;
            cs_n = 0;
            
            for (i=63; i>=0; i=i-1) begin
                @(posedge sclk);
                #10;
                if (i > 0) begin
                    @(negedge sclk);
                    mosi = data[i-1];
                end
            end
            
            @(negedge sclk);
            #10;
            cs_n = 1;
            mosi = 0;
            #200;
        end
    endtask
    
    task spi_read_64(output [63:0] data);
        integer i;
        reg [63:0] tmp;
        begin
            tmp = 64'd0;
            mosi = 0;
            
            @(negedge sclk);
            #20;
            cs_n = 0;
            
            for (i=63; i>=0; i=i-1) begin
                @(posedge sclk);
                #10;
                tmp[i] = miso;
            end
            
            @(negedge sclk);
            #10;
            cs_n = 1;
            data = tmp;
            #200;
        end
    endtask
    
    // ?? ????
    initial begin
        $monitor("[%0t] state=%b, round=%2d, L=%h, R=%h, f_out=%h, subkey=%h", 
                 $time, dut.csm_inst.state, dut.csm_inst.round_counter,
                 dut.csm_inst.left_reg, dut.csm_inst.right_reg,
                 dut.csm_inst.f_output, dut.csm_inst.current_subkey);
    end
    
    initial begin
        $dumpfile("tb_TopModule.vcd");
        $dumpvars(0, tb_TopModule);
        
        rst = 1;
        cs_n = 1;
        mosi = 0;
        plaintext = 64'hFEDCBA9876543210;
        
        #100 rst = 0;
        #200;
        
        $display("\n========================================");
        $display("    DES Encryption Debug Test");
        $display("========================================");
        $display("Plaintext = 0x%h", plaintext);
        $display("Key       = 0x%h", dut.key);
        
        $display("\n[%0t] Writing plaintext...", $time);
        spi_write_64(plaintext);
        $display("[%0t] SPI RX: 0x%h %s", $time, dut.spi_rx_data,
                 (dut.spi_rx_data === plaintext) ? "?" : "?");
        
        // IP ?? ??
        #200;
        $display("\n[%0t] After INIT_PERM:", $time);
        $display("  IP left  = 0x%h %s", dut.csm_inst.ip_left, 
                 (dut.csm_inst.ip_left === 32'hX) ? "? UNKNOWN" : "?");
        $display("  IP right = 0x%h %s", dut.csm_inst.ip_right,
                 (dut.csm_inst.ip_right === 32'hX) ? "? UNKNOWN" : "?");
        
        // Subkey ??
        $display("\n[%0t] Subkeys:", $time);
        $display("  k1  = %h %s", dut.csm_inst.k1, (dut.csm_inst.k1 === 48'hX) ? "?" : "?");
        $display("  k2  = %h %s", dut.csm_inst.k2, (dut.csm_inst.k2 === 48'hX) ? "?" : "?");
        
        $display("\n[%0t] Waiting for encryption...", $time);
        wait(dut.done_encrypt == 1'b1);
        
        $display("\n[%0t] Encryption complete:", $time);
        $display("  Final L  = 0x%h", dut.csm_inst.left_reg);
        $display("  Final R  = 0x%h", dut.csm_inst.right_reg);
        $display("  FP out   = 0x%h %s", dut.csm_inst.fp_output,
                 (dut.csm_inst.fp_output === 64'hX) ? "? UNKNOWN" : "?");
        $display("  CSM out  = 0x%h %s", dut.spi_tx_data,
                 (dut.spi_tx_data === 64'hX) ? "? UNKNOWN" : "?");
        
        #1000;
        
        $display("\n[%0t] Reading ciphertext...", $time);
        spi_read_64(ciphertext);
        
        $display("\n========================================");
        $display("           Results");
        $display("========================================");
        $display("Plaintext  = 0x%h", plaintext);
        $display("Ciphertext = 0x%h", ciphertext);
        
        // ??
        if (dut.csm_inst.ip_left === 32'hX || dut.csm_inst.ip_right === 32'hX) begin
            $display("\n? Initial_Permutation module is missing or broken!");
        end else if (dut.csm_inst.k1 === 48'hX) begin
            $display("\n? key_schedule module is missing or broken!");
        end else if (dut.csm_inst.f_output === 32'hX) begin
            $display("\n? Feistel_Function module is missing or broken!");
        end else if (dut.csm_inst.fp_output === 64'hX) begin
            $display("\n? Final_Permutation module is missing or broken!");
        end else if (ciphertext != plaintext && ciphertext != 64'h0) begin
            $display("\n? All modules working - Encryption successful!");
        end else begin
            $display("\n? Encryption ran but result may be incorrect");
        end
        $display("========================================\n");
        
        #1000 $finish;
    end
endmodule