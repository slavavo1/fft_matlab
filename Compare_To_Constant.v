// -------------------------------------------------------------
// 
// File Name: hdlsrc\fft_new\Compare_To_Constant.v
// Created: 2025-06-03 14:06:56
// 
// Generated by MATLAB 9.12 and HDL Coder 3.20
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: Compare_To_Constant
// Source Path: fft_new/Subsystem2/Compare To Constant
// Hierarchy Level: 2
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module Compare_To_Constant
          (u,
           y);


  input   [7:0] u;  // uint8
  output  y;


  wire [7:0] Constant_out1;  // uint8
  wire Compare_relop1;


  assign Constant_out1 = 8'b01111111;



  assign Compare_relop1 = u <= Constant_out1;



  assign y = Compare_relop1;

endmodule  // Compare_To_Constant

