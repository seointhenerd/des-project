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
  
  // MISO output: masked when chip select is high
  assign miso = miso_q & ~cs_n;
  
  // Shift in MOSI data on rising SCLK
  always @(posedge sclk or negedge rst) begin
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
  
  // Shift out MISO data on falling SCLK
  // Load output_text when cs_n goes low
  always @(negedge sclk or negedge rst) begin
    if (!rst) begin
      miso_q    <= 1'b0;
      shreg_out <= 64'd0;
    end else if (cs_n) begin
      // Load new data when deselected (ready for next transaction)
      miso_q    <= output_text[63];
      shreg_out <= {output_text[62:0], 1'b0};
    end else begin
      // Shift out during active transaction
      miso_q    <= shreg_out[63];
      shreg_out <= {shreg_out[62:0], 1'b0};
    end
  end

endmodule
