`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2019 13:12:56
// Design Name: 
// Module Name: MD5_tb
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


module MD5_tb(
    );
    reg clock_tb =0 ;
    reg[447:0] message_tb = "test";
    reg [63:0] message_length_tb = 'd4;
    wire [511:0] message_out_tb;
    wire [127:0] hash_tb;
    
    MD5 DUT(
    .clock(clock_tb),
    .message(message_tb),      
    .message_length(message_length_tb),
    .message_out(message_out_tb),  
    .hash(hash_tb)          
    );
    
    always begin
    #1 clock_tb = ! clock_tb;
    end
    
endmodule
