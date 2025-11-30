`timescale 1ns / 1ps

module tb_Initial_Permutation;

reg  [63:0] input_text;
wire [31:0] left_half;
wire [31:0] right_half;
integer i;
integer error_count;

Initial_Permutation DUT (
    .input_text(input_text),
    .left_half(left_half),
    .right_half(right_half)
);

initial begin
    error_count = 0;

    // Check the IP_table value
    $display("Testing IP_table initialization:");
    #1;
    $display("IP_table[24] = %0d (expected 64)", DUT.IP_table[24]);
    $display("IP_table[39] = %0d (expected 1)",  DUT.IP_table[39]);
    $display("IP_table[63] = %0d (expected 7)",  DUT.IP_table[63]);
    $display("IP_table[0]  = %0d (expected 58)", DUT.IP_table[0]);
    $display("");

    // All-one input test (check X/Z)
    $display("Testing all-one input (check X/Z):");
    input_text = 64'hFFFFFFFFFFFFFFFF;
    #10;

    for (i = 0; i < 64; i = i + 1) begin
        if (i < 32) begin
            if (right_half[i] === 1'bx || right_half[i] === 1'bz) begin
                $display("ERROR: Output bit %2d (right_half[%2d]) = X/Z", i, i);
                error_count = error_count + 1;
            end else begin
                $display("Output bit %2d (right_half[%2d]) = %b", i, i, right_half[i]);
            end
        end else begin
            if (left_half[i-32] === 1'bx || left_half[i-32] === 1'bz) begin
                $display("ERROR: Output bit %2d (left_half[%2d]) = X/Z", i, i-32);
                error_count = error_count + 1;
            end else begin
                $display("Output bit %2d (left_half[%2d]) = %b", i, i-32, left_half[i-32]);
            end
        end
    end
    $display("");

    // Simple input test (only bit 0 = 1)
    $display("Testing simple input (only bit 0 = 1):");
    input_text = 64'h0000_0000_0000_0001;
    #10;
    $display("Input    = %h", input_text);
    $display("Left     = %h", left_half);
    $display("Right    = %h", right_half);
    $display("Combined = %h", {left_half, right_half});
    $display("");

    // All-zero input test
    $display("Testing all-zero input:");
    input_text = 64'h0000_0000_0000_0000;
    #10;
    if (left_half === 32'h0 && right_half === 32'h0) begin
        $display("PASSED: All zeros test");
    end else begin
        $display("FAILED: All zeros test (Left=%h, Right=%h)", left_half, right_half);
        error_count = error_count + 1;
    end
    $display("");

    // DES standard input vector test
    $display("Testing DES standard input vector:");
    input_text = 64'h0123_4567_89AB_CDEF;
    #10;
    $display("Input    = %h", input_text);
    $display("Left     = %h (expected: cc00ccff)", left_half);
    $display("Right    = %h (expected: f0aaf0aa)", right_half);

    if (left_half === 32'hCC00_CCFF && right_half === 32'hF0AA_F0AA) begin
        $display("PASSED: DES test vector");
    end else begin
        $display("FAILED: DES test vector");
        error_count = error_count + 1;
    end
    $display("");

    // 1122334455667788 test
    $display("Testing input 1122334455667788 :");
    input_text = 64'h1122_3344_5566_7788;
    #10;
    $display("Input    = %h", input_text);

    $display("Left     = %h (expected: 78557855)", left_half);
    $display("Right    = %h (expected: 80668066)", right_half);

    if (left_half === 32'h78557855 && right_half === 32'h80668066) begin
        $display("PASSED: DES test vector");
    end else begin
        $display("FAILED: DES test vector");
        error_count = error_count + 1;
    end
    $display("");
    $display("========================================");
    if (error_count == 0)
        $display("ALL TESTS PASSED!");
    else
        $display("%0d TEST(S) FAILED", error_count);
    $display("========================================\n");

    $stop;
end
endmodule
