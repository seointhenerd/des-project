`timescale 1ns/1ps
module tb_TopModule();
    reg clk, rst, sclk, cs_n, mosi;
    wire miso;
    reg [63:0] originaltext;
    reg [63:0] ciphertext;
    reg [63:0] expected_cipher;
    
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
    
    task test_des(input [63:0] ot, input [63:0] expected);
        begin
            $display("\n[%0t] Testing DES...", $time);
            $display("  original text = 0x%h", ot);
            $display("  Key       = 0x%h", dut.key);
            $display("  Expected  = 0x%h", expected);
            
            spi_write_64(ot);
            @(posedge dut.done_encryot);
            #1000;
            spi_read_64(ciphertext);
            
            $display("  Result    = 0x%h", ciphertext);
            
            if (ciphertext === expected) begin
                $display("PASS");
            end else begin
                $display("FAIL");
            end
        end
    endtask
    
    initial begin
        rst = 1;
        cs_n = 1;
        mosi = 0;
        
        #100 rst = 0;
        #200;
        
        $display("    DES Encryotion Validation Test");
        
        test_des(64'hFEDCBA9876543210, 64'h21C9195F0A478337);
        
        #1000 $stop;
    end
endmodule
