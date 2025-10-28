// -----------------------------------------------------------------------------
// Simple SPI interface for 64-bit transfer (Mode 0)
// [28]=MSB, [1]=LSB convention not relevant here ? pure serial link.
// - Receives 64 bits on MOSI (sampled on rising edge of SCLK when CS=0)
// - Shifts out 64 bits on MISO (MSB first, updated on falling edge)
// - Latches input_text after 64 bits received
// -----------------------------------------------------------------------------
module SPI (
  input  wire        rst,         // active-low asynchronous reset
  input  wire        sclk,        // SPI clock from master (CPOL=0, CPHA=0)
  input  wire        cs_n,        // chip select, active low
  input  wire        mosi,        // master out
  output wire        miso,        // master in (tri-stated when CS_n=1)
  input  wire [63:0] output_text, // 64-bit word to transmit
  output reg  [63:0] input_text   // 64-bit word received
);

  reg [63:0] shreg_in;
  reg [63:0] shreg_out;
  reg [6:0]  bit_cnt;
  reg        miso_q;

  assign miso = (cs_n == 1'b0) ? miso_q : 1'bz;

  // Prime MISO when chip select goes low (first bit ready before 1st clock)
  always @(negedge cs_n or negedge rst) begin
    if (!rst) begin
      shreg_out <= 64'd0;
      miso_q    <= 1'b0;
    end else begin
      miso_q    <= output_text[63];             // MSB first
      shreg_out <= {output_text[62:0], 1'b0};   // preload remaining bits
    end
  end

  // Shift in MOSI data on rising SCLK
  always @(posedge sclk or posedge cs_n or negedge rst) begin
    if (!rst) begin
      shreg_in   <= 64'd0;
      bit_cnt    <= 7'd0;
      input_text <= 64'd0;
    end else if (cs_n) begin
      bit_cnt <= 7'd0;
    end else begin
      shreg_in <= {shreg_in[62:0], mosi};
      bit_cnt  <= bit_cnt + 7'd1;
      if (bit_cnt == 7'd63)
        input_text <= {shreg_in[62:0], mosi};
    end
  end

  // Shift out next MISO bit on falling SCLK
  always @(negedge sclk or posedge cs_n or negedge rst) begin
    if (!rst) begin
      miso_q    <= 1'b0;
      shreg_out <= 64'd0;
    end else if (cs_n) begin
      miso_q <= 1'b0;
    end else begin
      miso_q    <= shreg_out[63];
      shreg_out <= {shreg_out[62:0], 1'b0};
    end
  end

endmodule
