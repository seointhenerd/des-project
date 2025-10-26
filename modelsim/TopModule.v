module TopModule (
    input  wire clk,
    input  wire rst,
    input  wire sclk,
    input  wire cs_n,
    input  wire mosi,
    output wire miso
);
    wire [63:0] spi_rx_data;
    wire [63:0] spi_tx_data;
    wire [63:0] key = 64'h0123456789ABCDEF;
    wire done_encrypt;
    reg  start_encrypt;
    reg  active;
    reg cs_n_meta, cs_n_sync, cs_n_prev; // 2 stage synchronizer
    wire cs_rise;

    // SPI
    SPI spi_inst (
        .rst        (~rst),
        .sclk       (sclk),
        .cs_n       (cs_n),
        .mosi       (mosi),
        .miso       (miso),
        .output_text(spi_tx_data),
        .input_text (spi_rx_data)
    );

    // CSM
    Control_State_Machine csm_inst (
        .clk          (clk),
        .rst          (rst),
        .start_encrypt(start_encrypt),
        .start_decrypt(1'b0),
        .key          (key),
        .input_text   (spi_rx_data),
        .done_encrypt (done_encrypt),
        .done_decrypt (), // update later
        .output_text  (spi_tx_data)
    );

    // CS synchronizer
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cs_n_meta <= 1'b1;
            cs_n_sync <= 1'b1;
            cs_n_prev <= 1'b1;
        end else begin
            cs_n_meta <= cs_n;
            cs_n_sync <= cs_n_meta;
            cs_n_prev <= cs_n_sync;
        end
    end

    assign cs_rise = (cs_n_prev == 1'b0) && (cs_n_sync == 1'b1);

    // start_encrypt
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            start_encrypt <= 1'b0;
        end else if (cs_rise && !active && (spi_rx_data != 64'h0)) begin
            start_encrypt <= 1'b1;
        end else begin
            start_encrypt <= 1'b0;
        end
    end

    // Active flag
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            active <= 1'b0;
        end else if (start_encrypt) begin
            active <= 1'b1;
        end else if (done_encrypt) begin
            active <= 1'b0;
        end
    end
endmodule
