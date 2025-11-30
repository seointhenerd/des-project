// Module to expand the right 32 bits to 64 bits using a DES table

module Expansion (
      input  wire [31:0] R_in,      // 32-bit right half
      output wire [47:0] E_out      // 48-bit expanded output
);



 assign E_out = {
          R_in[0],  R_in[31], R_in[30], R_in[29], R_in[28], R_in[27],
          R_in[28], R_in[27], R_in[26], R_in[25], R_in[24], R_in[23],
          R_in[24], R_in[23], R_in[22], R_in[21], R_in[20], R_in[19],
          R_in[20], R_in[19], R_in[18], R_in[17], R_in[16], R_in[15],
          R_in[16], R_in[15], R_in[14], R_in[13], R_in[12], R_in[11],
          R_in[12], R_in[11], R_in[10], R_in[9],  R_in[8],  R_in[7],
          R_in[8],  R_in[7],  R_in[6],  R_in[5],  R_in[4],  R_in[3],
          R_in[4],  R_in[3],  R_in[2],  R_in[1],  R_in[0],  R_in[31]
      };

endmodule