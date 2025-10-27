// -----------------------------------------------------------------------------
// Right register for DES 
// Expects R_next_in = L_prev ^ F(R_prev, K) to be computed externally.
// On init load: R_curr <= R_0
// On round step (en=1): R_curr <= R_next_in
// -----------------------------------------------------------------------------
module right_reg #(
    parameter WIDTH = 32
)(
    input  wire               clk,
    input  wire               rst,        // active-low async reset
    input  wire               en,         // step a round when 1
    input  wire               load_init,  // load R_0 when 1
    input  wire [WIDTH-1:0]   R_0,        // initial right half
    input  wire [WIDTH-1:0]   R_in,       // = L_{n-1} ^ f(R_{n-1}, K_n), computed upstream
    output reg  [WIDTH-1:0]   R_curr      // current right half
);
    wire [WIDTH-1:0] R_next = load_init ? R_0 :
                              en        ? R_in :
                                          R_curr;   // hold

    always @(posedge clk or negedge rst) begin
        if (!rst)
            R_curr <= {WIDTH{1'b0}};
        else
            R_curr <= R_next;
    end
endmodule
