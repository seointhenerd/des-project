module Initial_Permutation (
    input  wire [63:0] input_text,
    output reg  [31:0] left_half,
    output reg  [31:0] right_half
);

    reg [6:0] IP_table [0:63];
    reg [63:0] permuted_data;
    integer i;

    initial begin
        IP_table[0]=7'd58; IP_table[1]=7'd50; IP_table[2]=7'd42; IP_table[3]=7'd34;
        IP_table[4]=7'd26; IP_table[5]=7'd18; IP_table[6]=7'd10; IP_table[7]=7'd2;
        IP_table[8]=7'd60; IP_table[9]=7'd52; IP_table[10]=7'd44; IP_table[11]=7'd36;
        IP_table[12]=7'd28; IP_table[13]=7'd20; IP_table[14]=7'd12; IP_table[15]=7'd4;
        IP_table[16]=7'd62; IP_table[17]=7'd54; IP_table[18]=7'd46; IP_table[19]=7'd38;
        IP_table[20]=7'd30; IP_table[21]=7'd22; IP_table[22]=7'd14; IP_table[23]=7'd6;
        IP_table[24]=7'd64; IP_table[25]=7'd56; IP_table[26]=7'd48; IP_table[27]=7'd40;
        IP_table[28]=7'd32; IP_table[29]=7'd24; IP_table[30]=7'd16; IP_table[31]=7'd8;
        IP_table[32]=7'd57; IP_table[33]=7'd49; IP_table[34]=7'd41; IP_table[35]=7'd33;
        IP_table[36]=7'd25; IP_table[37]=7'd17; IP_table[38]=7'd9;  IP_table[39]=7'd1;
        IP_table[40]=7'd59; IP_table[41]=7'd51; IP_table[42]=7'd43; IP_table[43]=7'd35;
        IP_table[44]=7'd27; IP_table[45]=7'd19; IP_table[46]=7'd11; IP_table[47]=7'd3;
        IP_table[48]=7'd61; IP_table[49]=7'd53; IP_table[50]=7'd45; IP_table[51]=7'd37;
        IP_table[52]=7'd29; IP_table[53]=7'd21; IP_table[54]=7'd13; IP_table[55]=7'd5;
        IP_table[56]=7'd63; IP_table[57]=7'd55; IP_table[58]=7'd47; IP_table[59]=7'd39;
        IP_table[60]=7'd31; IP_table[61]=7'd23; IP_table[62]=7'd15; IP_table[63]=7'd7;
    end

    always @(input_text) begin
        for (i = 0; i < 64; i = i + 1) begin
            permuted_data[i] = input_text[IP_table[i] - 1];
        end
        left_half  = permuted_data[63:32];
        right_half = permuted_data[31:0];
    end

endmodule

