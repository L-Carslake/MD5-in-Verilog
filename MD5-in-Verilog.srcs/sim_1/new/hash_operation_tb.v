`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2019 16:01:06
// Design Name: 
// Module Name: hash_operation_tb
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


module hash_operation_tb(
    );
    reg clock_tb = 0;
    reg [31:0] a_in_tb  = 'h67452301;            
    reg [31:0] b_in_tb;            
    reg [31:0] c_in_tb;            
    reg [31:0] d_in_tb;            
    reg [511:0] message_in_tb;
    
    wire [31:0] a_out_tb;          
    wire [31:0] b_out_tb;          
    wire [31:0] c_out_tb;          
    wire [31:0] d_out_tb;          
    wire [511:0] message_out_tb;
    
   
    
    initial begin
    message_in_tb = 512'h74736574;
    end
    
    hash_operation DUT(
     .clock(clock_tb),
     .a_in(a_in_tb),
     .b_in(b_in_tb),
     .c_in(c_in_tb),
     .d_in(d_in_tb),
     .message_in(message_in_tb),
     .a_out(a_out_tb),
     .b_out(b_out_tb),
     .c_out(c_out_tb),
     .d_out(d_out_tb),
     .message_out(message_out_tb)
    );
    
    always begin
    #1 clock_tb = ~clock_tb;
    end 
    
    
endmodule
