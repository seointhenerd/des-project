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

  // Removed 'bz; mask with ~cs_n instead
  assign miso = miso_q & ~cs_n;

  // Track CS state for edge detection
  reg cs_n_prev;

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

  // Combined block: handles CS edge detection and SCLK shifting
  // This eliminates multiple drivers on shreg_out and miso_q
  always @(negedge sclk or negedge cs_n or posedge cs_n or negedge rst) begin
    if (!rst) begin
      miso_q     <= 1'b0;
      shreg_out  <= 64'd0;
      cs_n_prev  <= 1'b1;
    end else begin
      cs_n_prev <= cs_n;

      if (!cs_n_prev && cs_n) begin
        // Rising edge of CS (deselection) - reset outputs
        miso_q <= 1'b0;
      end else if (cs_n_prev && !cs_n) begin
        // Falling edge of CS (selection) - prime MISO with first bit
        miso_q    <= output_text[63];             // MSB first
        shreg_out <= {output_text[62:0], 1'b0};   // preload remaining bits
      end else if (!cs_n) begin
        // CS is low and stable - shift on falling SCLK edge
        miso_q    <= shreg_out[63];
        shreg_out <= {shreg_out[62:0], 1'b0};
      end
    end
  end

endmodule

