module SPI (
  input  wire        rst,         
  input  wire        sclk,        
  input  wire        cs_n,        
  input  wire        mosi,        
  output reg         miso,
  input  wire [63:0] output_text, 
  output reg  [63:0] input_text   
);

  reg [63:0] shreg_in;
  reg [63:0] shreg_out;
  reg [6:0]  bit_cnt;
  reg        cs_n_prev;

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

  always @(negedge sclk or posedge cs_n or negedge rst) begin
    if (!rst) begin
      miso       <= 1'b0;
      shreg_out  <= 64'd0;
      cs_n_prev  <= 1'b1;
    end else begin
      cs_n_prev <= cs_n;

      if (cs_n_prev && !cs_n) begin
        // Falling edge of CS_n — activate chip, preload
        miso       <= output_text[63];
        shreg_out  <= {output_text[62:0], 1'b0};
      end else if (!cs_n) begin
        // CS active, shift bits
        miso       <= shreg_out[63];
        shreg_out  <= {shreg_out[62:0], 1'b0};
      end else begin
        // CS high — idle state
        miso <= 1'b0;
      end
    end
  end

endmodule

