module Final_Permutation (
    input  wire [31:0] left_half,
    input  wire [31:0] right_half,
    output reg  [63:0] output_text
);

    // DES IP^-1 (Inverse Initial Permutation) table
    reg [6:0] FP_table [0:63];
    reg [63:0] combined;
    integer i;

    initial begin
        FP_table[0]=7'd40; FP_table[1]=7'd8;  FP_table[2]=7'd48; FP_table[3]=7'd16;
        FP_table[4]=7'd56; FP_table[5]=7'd24; FP_table[6]=7'd64; FP_table[7]=7'd32;
        FP_table[8]=7'd39; FP_table[9]=7'd7;  FP_table[10]=7'd47; FP_table[11]=7'd15;
        FP_table[12]=7'd55; FP_table[13]=7'd23; FP_table[14]=7'd63; FP_table[15]=7'd31;
        FP_table[16]=7'd38; FP_table[17]=7'd6;  FP_table[18]=7'd46; FP_table[19]=7'd14;
        FP_table[20]=7'd54; FP_table[21]=7'd22; FP_table[22]=7'd62; FP_table[23]=7'd30;
        FP_table[24]=7'd37; FP_table[25]=7'd5;  FP_table[26]=7'd45; FP_table[27]=7'd13;
        FP_table[28]=7'd53; FP_table[29]=7'd21; FP_table[30]=7'd61; FP_table[31]=7'd29;
        FP_table[32]=7'd36; FP_table[33]=7'd4;  FP_table[34]=7'd44; FP_table[35]=7'd12;
        FP_table[36]=7'd52; FP_table[37]=7'd20; FP_table[38]=7'd60; FP_table[39]=7'd28;
        FP_table[40]=7'd35; FP_table[41]=7'd3;  FP_table[42]=7'd43; FP_table[43]=7'd11;
        FP_table[44]=7'd51; FP_table[45]=7'd19; FP_table[46]=7'd59; FP_table[47]=7'd27;
        FP_table[48]=7'd34; FP_table[49]=7'd2;  FP_table[50]=7'd42; FP_table[51]=7'd10;
        FP_table[52]=7'd50; FP_table[53]=7'd18; FP_table[54]=7'd58; FP_table[55]=7'd26;
        FP_table[56]=7'd33; FP_table[57]=7'd1;  FP_table[58]=7'd41; FP_table[59]=7'd9;
        FP_table[60]=7'd49; FP_table[61]=7'd17; FP_table[62]=7'd57; FP_table[63]=7'd25;
    end

    always @(left_half or right_half) begin
        combined[63:32] = left_half;
        combined[31:0]  = right_half;
        for (i = 0; i < 64; i = i + 1) begin
            output_text[i] = combined[FP_table[i] - 1];
        end
    end

endmodule

