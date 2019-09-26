`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2019 11:14:54
// Design Name: 
// Module Name: MD5
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////





module MD5(
    );
  reg [32:0] per_round_shift_amounts [0:63], sines_of_integers [0:63];  
  
  //Read in values from external memory files 
  initial begin 
    $readmemh("per-shift-amounts.mem", per_round_shift_amounts);
    $readmemh("sines-of-integers.mem", sines_of_integers);
  end
  
  //Initialize variables:
  reg [32:0] a0 = 'h67452301, b0 = 'hefcdab89, c0 = 'h98badcfe, d0 = 'h10325476;
  
  //Pre-processing: adding a single 1 bit
  
   
endmodule
