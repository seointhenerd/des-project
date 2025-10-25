`timescale 1ns/1ps
module tb_key_schedule;
  // input
  reg  [64:1] key;

  // outputs
  wire [48:1] k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16;

  // DUT
  key_schedule dut (
    .key (key),
    .k1  (k1),  .k2 (k2),  .k3 (k3),  .k4 (k4),
    .k5  (k5),  .k6 (k6),  .k7 (k7),  .k8 (k8),
    .k9  (k9),  .k10(k10), .k11(k11), .k12(k12),
    .k13 (k13), .k14(k14), .k15(k15), .k16(k16)
  );

  task show_subkeys(input [64:1] k);
    begin
      $display("\nKey = 0x%016h", k);
      $display("K1  = 0x%012h", k1);
      $display("K2  = 0x%012h", k2);
      $display("K3  = 0x%012h", k3);
      $display("K4  = 0x%012h", k4);
      $display("K5  = 0x%012h", k5);
      $display("K6  = 0x%012h", k6);
      $display("K7  = 0x%012h", k7);
      $display("K8  = 0x%012h", k8);
      $display("K9  = 0x%012h", k9);
      $display("K10 = 0x%012h", k10);
      $display("K11 = 0x%012h", k11);
      $display("K12 = 0x%012h", k12);
      $display("K13 = 0x%012h", k13);
      $display("K14 = 0x%012h", k14);
      $display("K15 = 0x%012h", k15);
      $display("K16 = 0x%012h", k16);
    end
  endtask

  initial begin
    // -------------------------------
    // Case 1: 0x133457799BBCDFF1
    // -------------------------------
    key = 64'h1334_5779_9BBC_DFF1;
    #20;
    show_subkeys(key);

    if (k1  !== 48'h1B02EFFC7072) $fatal(1);
    if (k2  !== 48'h79AED9DBC9E5) $fatal(1);
    if (k3  !== 48'h55FC8A42CF99) $fatal(1);
    if (k4  !== 48'h72ADD6DB351D) $fatal(1);
    if (k5  !== 48'h7CEC07EB53A8) $fatal(1);
    if (k6  !== 48'h63A53E507B2F) $fatal(1);
    if (k7  !== 48'hEC84B7F618BC) $fatal(1);
    if (k8  !== 48'hF78A3AC13BFB) $fatal(1);
    if (k9  !== 48'hE0DBEBEDE781) $fatal(1);
    if (k10 !== 48'hB1F347BA464F) $fatal(1);
    if (k11 !== 48'h215FD3DED386) $fatal(1);
    if (k12 !== 48'h7571F59467E9) $fatal(1);
    if (k13 !== 48'h97C5D1FABA41) $fatal(1);
    if (k14 !== 48'h5F43B7F2E73A) $fatal(1);
    if (k15 !== 48'hBF918D3D3F0A) $fatal(1);
    if (k16 !== 48'hCB3D8B0E17F5) $fatal(1);

    $display("[PASS] key 0x%016h", key);

    // -------------------------------
    // Case 2: 0x0000000000000000
    // -------------------------------
    #40;
    key = {64{1'b0}};
    #20;
    show_subkeys(key);

    if (k1  !== 48'h000000000000) $fatal(1);
    if (k2  !== 48'h000000000000) $fatal(1);
    if (k3  !== 48'h000000000000) $fatal(1);
    if (k4  !== 48'h000000000000) $fatal(1);
    if (k5  !== 48'h000000000000) $fatal(1);
    if (k6  !== 48'h000000000000) $fatal(1);
    if (k7  !== 48'h000000000000) $fatal(1);
    if (k8  !== 48'h000000000000) $fatal(1);
    if (k9  !== 48'h000000000000) $fatal(1);
    if (k10 !== 48'h000000000000) $fatal(1);
    if (k11 !== 48'h000000000000) $fatal(1);
    if (k12 !== 48'h000000000000) $fatal(1);
    if (k13 !== 48'h000000000000) $fatal(1);
    if (k14 !== 48'h000000000000) $fatal(1);
    if (k15 !== 48'h000000000000) $fatal(1);
    if (k16 !== 48'h000000000000) $fatal(1);

    $display("[PASS] key 0x%016h", key);

    // -------------------------------
    // Case 3: 0xFFFFFFFFFFFFFFFF
    // -------------------------------
    #40;
    key = {64{1'b1}};
    #20;
    show_subkeys(key);

    if (k1  !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k2  !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k3  !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k4  !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k5  !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k6  !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k7  !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k8  !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k9  !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k10 !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k11 !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k12 !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k13 !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k14 !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k15 !== 48'hFFFFFFFFFFFF) $fatal(1);
    if (k16 !== 48'hFFFFFFFFFFFF) $fatal(1);

    $display("[PASS] key 0x%016h", key);

    // -------------------------------
    // Case 4: 0x0123456789ABCDEF
    // -------------------------------
    #40;
    key = 64'h0123_4567_89AB_CDEF;
    #20;
    show_subkeys(key);

    if (k1  !== 48'h0B02679B49A5) $fatal(1);
    if (k2  !== 48'h69A659256A26) $fatal(1);
    if (k3  !== 48'h45D48AB428D2) $fatal(1);
    if (k4  !== 48'h7289D2A58257) $fatal(1);
    if (k5  !== 48'h3CE80317A6C2) $fatal(1);
    if (k6  !== 48'h23251E3C8545) $fatal(1);
    if (k7  !== 48'h6C04950AE4C6) $fatal(1);
    if (k8  !== 48'h5788386CE581) $fatal(1);
    if (k9  !== 48'hC0C9E926B839) $fatal(1);
    if (k10 !== 48'h91E307631D72) $fatal(1);
    if (k11 !== 48'h211F830D893A) $fatal(1);
    if (k12 !== 48'h7130E5455C54) $fatal(1);
    if (k13 !== 48'h91C4D04980FC) $fatal(1);
    if (k14 !== 48'h5443B681DC8D) $fatal(1);
    if (k15 !== 48'hB691050A16B5) $fatal(1);
    if (k16 !== 48'hCA3D03B87032) $fatal(1);

    $display("[PASS] key 0x%016h", key);

    $display("key_schedule: all tests PASSED");
    #100;
    $stop;
  end
endmodule
