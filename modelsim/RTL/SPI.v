module SPI (
  input  wire        rst,
  input  wire        sclk,
  input  wire        cs_n,
  input  wire        mosi,
  output wire        miso,
  input  wire [63:0] output_text,
  output reg  [63:0] input_text
);

  // Input shift register
  reg [63:0] shift_in;
  reg [6:0]  in_count;
  
  // Output shift register
  reg [63:0] shift_out;
  reg [6:0]  out_count;
  reg        miso_reg;
  reg        cs_prev;
  
  assign miso = miso_reg;

  // MOSI Input: Sample on posedge sclk
  always @(posedge sclk or negedge rst) begin
    if (!rst) begin
      shift_in   <= 64'h0;
      in_count   <= 7'd0;
      input_text <= 64'h0;
      cs_prev    <= 1'b1;
    end else begin
      cs_prev <= cs_n;
      
      if (!cs_n) begin
        // Shift in MOSI
        shift_in <= {shift_in[62:0], mosi};
        in_count <= in_count + 7'd1;
        
        // Capture after 64 bits
        if (in_count == 7'd63) begin
          input_text <= {shift_in[62:0], mosi};
          in_count   <= 7'd0;
        end
      end else begin
        in_count <= 7'd0;
      end
      
      // Detect CS falling edge and preload MISO immediately
      if (cs_prev && !cs_n) begin
        miso_reg  <= output_text[63];
        shift_out <= {output_text[62:0], 1'b0};
        out_count <= 7'd1;
      end
    end
  end

  // MISO Output: Shift on negedge sclk
  always @(negedge sclk or negedge rst) begin
    if (!rst) begin
      shift_out <= 64'h0;
      out_count <= 7'd0;
    end else begin
      if (!cs_n && out_count != 7'd0) begin
        // Shift out subsequent bits
        miso_reg  <= shift_out[63];
        shift_out <= {shift_out[62:0], 1'b0};
        out_count <= out_count + 7'd1;
        
        if (out_count == 7'd63) begin
          out_count <= 7'd0;
        end
      end else if (cs_n) begin
        out_count <= 7'd0;
      end
    end
  end

endmodule
