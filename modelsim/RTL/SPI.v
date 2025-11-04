module SPI (
  input  wire        rst,         // active-low asynchronous reset
  input  wire        sclk,        // SPI clock from master (CPOL=0, CPHA=0)
  input  wire        cs_n,        // chip select, active low
  input  wire        mosi,        // master out
  output wire        miso,        // master in (drives 0 when CS_n=1)
  input  wire [63:0] output_text, // 64-bit word to transmit
  output reg  [63:0] input_text   // 64-bit word received
);

  reg [63:0] shreg_in;
  reg [63:0] shreg_out;
  reg [6:0]  bit_cnt;
  reg        miso_q;

  // Combinationally output first bit when CS goes low, then use registered value
  wire first_bit_mux;
  reg cs_n_d1;

  // Detect if this is the very first bit (CS just went low, before any SCLK)
  assign first_bit_mux = cs_n_d1 & ~cs_n;

  // Mux between first bit (direct from output_text) and shifted bits (from miso_q)
  assign miso = (first_bit_mux ? output_text[63] : miso_q) & ~cs_n;

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

  // Track CS state (delayed version for edge detection)
  // Sample CS on every SCLK negedge, and also respond to CS going high
  always @(negedge sclk or posedge cs_n or negedge rst) begin
    if (!rst) begin
      cs_n_d1 <= 1'b1;
    end else if (cs_n) begin
      // CS went high - reset to prepare for next transaction
      cs_n_d1 <= 1'b1;
    end else begin
      cs_n_d1 <= cs_n;
    end
  end

  // Handle MISO shifting on falling SCLK edge
  // Load on first negedge after CS falls, then shift normally
  always @(negedge sclk or negedge rst) begin
    if (!rst) begin
      miso_q    <= 1'b0;
      shreg_out <= 64'd0;
    end else if (cs_n) begin
      // CS high - reset
      miso_q    <= 1'b0;
      shreg_out <= 64'd0;
    end else if (cs_n_d1 && !cs_n) begin
      // First SCLK negedge after CS went low - load data for bits 62:0
      miso_q    <= output_text[62];             // Second bit (bit 63 is muxed directly)
      shreg_out <= {output_text[61:0], 2'b0};   // Remaining bits
    end else begin
      // Normal shifting
      miso_q    <= shreg_out[63];
      shreg_out <= {shreg_out[62:0], 1'b0};
    end
  end

endmodule

