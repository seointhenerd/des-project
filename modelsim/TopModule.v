module TopModule (
    input  wire clk,
    input  wire rst,
    input  wire sclk,
    input  wire cs_n,
    input  wire mosi,
    output wire miso
);
    // SPI signals
    wire [63:0] spi_rx_data;
    wire [63:0] spi_tx_data;
    
    // DES control registers
    reg [63:0] key_reg;
    reg [63:0] data_reg;
    reg crypt;  // 0=encrypt, 1=decrypt
    
    // DES status signals
    wire done_encrypt, done_decrypt;
    reg start_encrypt, start_decrypt;
    reg active;
    reg done_encrypt_latched, done_decrypt_latched;
    
    // CS synchronizer
    reg cs_meta, cs_sync, cs_prev;
    wire cs_rise;
    reg cs_rise_delayed;  // delayed by 1 cycle - safe data capture
    
    // Transaction state: 0=KEY, 1=DATA, 2=CONTROL, 3=WAIT
    reg [1:0] transaction_state;
    
    // Delayed trigger flag
    reg trigger_operation;

    SPI spi_inst (
        .rst        (~rst),
        .sclk       (sclk),
        .cs_n       (cs_n),
        .mosi       (mosi),
        .miso       (miso),
        .output_text(spi_tx_data),
        .input_text (spi_rx_data)
    );
    
    Control_State_Machine csm_inst (
        .clk          (clk),
        .rst          (rst),
        .start_encrypt(start_encrypt),
        .start_decrypt(start_decrypt),
        .key          (key_reg),
        .input_text   (data_reg),
        .done_encrypt (done_encrypt),
        .done_decrypt (done_decrypt),
        .output_text  (spi_tx_data)
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cs_meta <= 1'b1;
            cs_sync <= 1'b1;
            cs_prev <= 1'b1;
            cs_rise_delayed <= 1'b0;
        end else begin
            cs_meta <= cs_n;
            cs_sync <= cs_meta;
            cs_prev <= cs_sync;
            cs_rise_delayed <= cs_rise;  // Delay by 1 cycle
        end
    end
    assign cs_rise = (cs_prev == 1'b0) && (cs_sync == 1'b1);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            transaction_state <= 2'd0;
            key_reg <= 64'h0;
            data_reg <= 64'h0;
            crypt <= 1'b0;
            trigger_operation <= 1'b0;
        end else begin
            trigger_operation <= 1'b0;  // clear trigger
            
            if (cs_rise_delayed) begin
                case (transaction_state)
                    2'd0: begin  // KEY state
                        if (spi_rx_data != 64'h0) begin
                            key_reg <= spi_rx_data;
                            transaction_state <= 2'd1;
                        end
                    end
                    2'd1: begin  // DATA state
                        if (spi_rx_data != 64'h0) begin
                            data_reg <= spi_rx_data;
                            transaction_state <= 2'd2;
                        end
                    end
                    2'd2: begin  // CONTROL state
                        crypt <= spi_rx_data[0]; // 0=encrypt, 1=decrypt
                        transaction_state <= 2'd3;
                        trigger_operation <= 1'b1;  // Trigger on next cycle
                    end
                    2'd3: begin  // WAIT state
                        if (!active) begin
                            transaction_state <= 2'd0;
                        end
                    end
                    default: transaction_state <= 2'd0;
                endcase
            end
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            start_encrypt <= 1'b0;
            start_decrypt <= 1'b0;
        end else if (trigger_operation && !active) begin
            if (crypt == 1'b0) begin
                start_encrypt <= 1'b1;
            end else begin
                start_decrypt <= 1'b1;
            end
        end else begin
            start_encrypt <= 1'b0;
            start_decrypt <= 1'b0;
        end
    end

    // active
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            active <= 1'b0;
        end else if (start_encrypt || start_decrypt) begin
            active <= 1'b1;
        end else if (done_encrypt || done_decrypt) begin
            active <= 1'b0;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done_encrypt_latched <= 1'b0;
            done_decrypt_latched <= 1'b0;
        end else begin
            if (done_encrypt) begin
                done_encrypt_latched <= 1'b1;
            end
            if (done_decrypt) begin
                done_decrypt_latched <= 1'b1;
            end
            
            if (cs_rise_delayed && transaction_state == 2'd0) begin
                done_encrypt_latched <= 1'b0;
                done_decrypt_latched <= 1'b0;
            end
        end
    end
    
endmodule
