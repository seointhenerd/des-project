`timescale 1ns/1ps

module tb_SPI;
  reg         rst;
  reg         sclk;
  reg         cs_n;
  reg         mosi;
  wire        miso;
  reg  [63:0] output_text;
  wire [63:0] input_text;
  
  SPI dut (
    .rst(rst),
    .sclk(sclk),
    .cs_n(cs_n),
    .mosi(mosi),
    .miso(miso),
    .output_text(output_text),
    .input_text(input_text)
  );
  
  // Clock: 20ns period (50MHz)
  initial begin
    sclk = 1'b0;
    forever #10 sclk = ~sclk;
  end
  
  // SPI Master transaction
  task spi_transfer;
    input  [63:0] tx_data;
    output [63:0] rx_data;
    integer i;
    begin
      rx_data = 64'h0;
      
      // Wait for negedge
      @(negedge sclk);
      
      // Set first MOSI bit and assert CS
      mosi = tx_data[63];
      cs_n = 1'b0;
      
      // First bit
      @(posedge sclk);
      #2;
      rx_data[63] = miso;
      
      // Remaining 63 bits
      for (i = 62; i >= 0; i = i - 1) begin
        @(negedge sclk);
        mosi = tx_data[i];
        
        @(posedge sclk);
        #2;
        rx_data[i] = miso;
      end
      
      // Deassert CS
      @(negedge sclk);
      cs_n = 1'b1;
      mosi = 1'b0;
      
      // Wait
      repeat(4) @(negedge sclk);
    end
  endtask
  
  // Test sequence
  reg [63:0] rx_data;
  integer errors;
  
  initial begin
    errors = 0;
    rst = 1'b0;
    cs_n = 1'b1;
    mosi = 1'b0;
    output_text = 64'h0;
    
    // Reset pulse
    #25;
    rst = 1'b1;
    #100;
    
    $display("\n========================================");
    $display("       SPI 64-BIT TEST");
    $display("========================================\n");
    
    //=== Test 1 ===
    $display("Test 1:");
    output_text = 64'hDEAD_BEEF_CAFE_FEED;
    spi_transfer(64'h0123_4567_89AB_CDEF, rx_data);
    
    $display("  MOSI sent: 0123456789ABCDEF");
    $display("  MOSI recv: %h %s", input_text, 
             (input_text == 64'h0123_4567_89AB_CDEF) ? "PASS" : "FAIL");
    if (input_text != 64'h0123_4567_89AB_CDEF) errors = errors + 1;
    
    $display("  MISO expt: DEADBEEFCAFEFEED");
    $display("  MISO recv: %h %s", rx_data,
             (rx_data == 64'hDEAD_BEEF_CAFE_FEED) ? "PASS" : "FAIL");
    if (rx_data != 64'hDEAD_BEEF_CAFE_FEED) errors = errors + 1;
    
    #200;
    
    //=== Test 2 ===
    $display("\nTest 2:");
    output_text = 64'h1122_3344_5566_7788;
    spi_transfer(64'hA5A5_F0F0_55AA_0F0F, rx_data);
    
    $display("  MOSI sent: A5A5F0F055AA0F0F");
    $display("  MOSI recv: %h %s", input_text,
             (input_text == 64'hA5A5_F0F0_55AA_0F0F) ? "PASS" : "FAIL");
    if (input_text != 64'hA5A5_F0F0_55AA_0F0F) errors = errors + 1;
    
    $display("  MISO expt: 1122334455667788");
    $display("  MISO recv: %h %s", rx_data,
             (rx_data == 64'h1122_3344_5566_7788) ? "PASS" : "FAIL");
    if (rx_data != 64'h1122_3344_5566_7788) errors = errors + 1;
    
    #200;
    
    $display("\n========================================");
    if (errors == 0) begin
      $display("       ALL TESTS PASSED!");
    end else begin
      $display("       %0d ERRORS DETECTED", errors);
    end
    $display("========================================\n");
    
    $stop;
  end

endmodule
