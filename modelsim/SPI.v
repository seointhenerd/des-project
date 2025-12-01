module SPI (
  input  wire        clk,
  input  wire        rst,
  input  wire        sclk,
  input  wire        cs_n,
  input  wire        mosi,
  output wire        miso,
  input  wire [63:0] output_text,
  output reg  [63:0] input_text
);
  // SCLK edge detection
  reg sclk_sync1, sclk_sync2, sclk_prev;
  wire sclk_posedge, sclk_negedge;
  
  // CS synchronization
  reg cs_sync1, cs_sync2, cs_prev;
  wire cs_negedge;
  
  // Shift registers
  reg [63:0] shift_in;
  reg [63:0] shift_out;
  reg [6:0]  bit_count;
  reg        miso_reg;
  reg        active;
  
  assign miso = miso_reg;
  
  // Synchronize sclk to clk domain
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      sclk_sync1 <= 1'b0;
      sclk_sync2 <= 1'b0;
      sclk_prev  <= 1'b0;
    end else begin
      sclk_sync1 <= sclk;
      sclk_sync2 <= sclk_sync1;
      sclk_prev  <= sclk_sync2;
    end
  end
  
  assign sclk_posedge = sclk_sync2 && !sclk_prev;
  assign sclk_negedge = !sclk_sync2 && sclk_prev;
  
  // Synchronize cs_n to clk domain
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      cs_sync1 <= 1'b1;
      cs_sync2 <= 1'b1;
      cs_prev  <= 1'b1;
    end else begin
      cs_sync1 <= cs_n;
      cs_sync2 <= cs_sync1;
      cs_prev  <= cs_sync2;
    end
  end
  
  assign cs_negedge = cs_prev && !cs_sync2;
  
  // Main SPI logic on clk domain
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      shift_in   <= 64'h0;
      shift_out  <= 64'h0;
      bit_count  <= 7'd0;
      miso_reg   <= 1'b0;
      input_text <= 64'h0;
      active     <= 1'b0;
    end else begin
      // CS falling edge - start transaction
      if (cs_negedge) begin
        bit_count  <= 7'd0;
        shift_in   <= 64'h0;
        shift_out  <= output_text;
        miso_reg   <= output_text[63];  // MSB first
        active     <= 1'b1;
      end
      // CS high - end transaction
      else if (cs_sync2) begin
        active <= 1'b0;
        if (bit_count == 7'd64) begin
          input_text <= shift_in;
        end
      end
      // Active transaction
      else if (active) begin
        // Sample MOSI on sclk rising edge (MSB first)
        if (sclk_posedge) begin
          shift_in <= {shift_in[62:0], mosi};  // Shift left, add new bit at LSB
          bit_count <= bit_count + 7'd1;
        end
        // Update MISO on sclk falling edge (MSB first)
        else if (sclk_negedge && bit_count < 7'd64) begin
          shift_out <= {shift_out[62:0], 1'b0};  // Shift left
          miso_reg  <= shift_out[62];  // Next MSB (already shifted)
        end
      end
    end
  end
  
endmodule
