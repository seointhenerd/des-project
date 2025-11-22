module top_pad (
    input  wire clk,
    input  wire rst,
    input  wire sclk,
    input  wire cs_n,
    input  wire mosi,
    output wire miso
);
    
    // Internal signals with _PAD suffix
    wire clk_PAD;
    wire rst_PAD;
    wire sclk_PAD;
    wire cs_n_PAD;
    wire mosi_PAD;
    wire miso_PAD;
    
    // Input pads
    pad_in clk_pad (
        .pad(clk), 
        .DataIn(clk_PAD)
    );
    
    pad_in rst_pad (
        .pad(rst), 
        .DataIn(rst_PAD)
    );
    
    pad_in sclk_pad (
        .pad(sclk), 
        .DataIn(sclk_PAD)
    );
    
    pad_in cs_n_pad (
        .pad(cs_n), 
        .DataIn(cs_n_PAD)
    );
    
    pad_in mosi_pad (
        .pad(mosi), 
        .DataIn(mosi_PAD)
    );
    
    // Output pad
    pad_out miso_pad (
        .pad(miso), 
        .DataOut(miso_PAD)
    );
    
    // Core module instantiation
    TopModule core (
        .clk  (clk_PAD),
        .rst  (rst_PAD),
        .sclk (sclk_PAD),
        .cs_n (cs_n_PAD),
        .mosi (mosi_PAD),
        .miso (miso_PAD)
    );
    
endmodule
