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
    .rst        (rst),
    .sclk       (sclk),
    .cs_n       (cs_n),
    .mosi       (mosi),
    .miso       (miso),
    .output_text(output_text),
    .input_text (input_text)
  );

  // SPI master frame: 64-bit transfer, Mode 0 (MSB first)
  task spi_frame64;
    input  [63:0] mosi_word;
    output [63:0] miso_word;
    integer i;
    begin
      cs_n = 1'b0; // select slave
      for (i = 63; i >= 0; i = i - 1) begin
        mosi = mosi_word[i];
        #2 sclk = 1'b1;         // rising: sample MOSI, master samples MISO
        miso_word[i] = miso;    // capture MISO on rising edge
        #2 sclk = 1'b0;         // falling: slave shifts next bit
      end
      cs_n = 1'b1; #2;          // deselect
    end
  endtask

  task expect64;
    input [63:0] got, exp;
    input [80*8:1] tag;
    begin
      if (got !== exp) begin
        $display("[FAIL] %0s  exp=0x%016h  got=0x%016h", tag, exp, got);
        $fatal(1);
      end else
        $display("[PASS] %0s  0x%016h", tag, got);
    end
  endtask

  reg [63:0] mosi_word;
  reg [63:0] miso_cap;

  initial begin
    // reset
    sclk = 1'b0; cs_n = 1'b1; mosi = 1'b0; output_text = 64'd0;
    rst  = 1'b0; #10; rst = 1'b1; #10;

    // Case 1
    mosi_word   = 64'h0123_4567_89AB_CDEF; // incoming data
    output_text = 64'hDEAD_BEEF_CAFE_FEED; // outgoing data
    spi_frame64(mosi_word, miso_cap);
    expect64(input_text, mosi_word, "INPUT_TEXT (from MOSI)");
    expect64(miso_cap,   output_text, "MISO stream (output_text)");

    // Case 2
    mosi_word   = 64'hA5A5_F0F0_55AA_0F0F;
    output_text = 64'h1122_3344_5566_7788;
    spi_frame64(mosi_word, miso_cap);
    expect64(input_text, mosi_word, "INPUT_TEXT #2");
    expect64(miso_cap,   output_text, "MISO stream #2");

    $display("SPI I/O 64 test: all passed ?");
    #20 $stop;
  end
endmodule
