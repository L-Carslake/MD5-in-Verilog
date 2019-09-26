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
    input wire clock,
    input wire [447:0] message,
    input wire [63:0]  message_length,
    output reg [511:0] message_out,
    output reg [127:0] hash
    );
    
    reg enable = 1;
    reg[511:0] message_padded = 0;
              
     //conenctions between generated instances        
    wire[31:0] con_a[0:64];
    wire[31:0] con_b[0:64];
    wire[31:0] con_c[0:64];
    wire[31:0] con_d[0:64];
    wire[511:0] con_message[0:64];
    
    localparam[31:0] a_initial = 'h67452301;
    localparam[31:0] b_initial = 'hefcdab89;
    localparam[31:0] c_initial = 'h98badcfe;
    localparam[31:0] d_initial = 'h10325476;
    
    assign con_a[0] = a_initial;
    assign con_b[0] = b_initial;
    assign con_c[0] = c_initial;
    assign con_d[0] = d_initial;
    assign con_message[0] = message_padded;
    
    generate
        genvar i;
        for(i=0;i<64;i=i+1)
        begin : generate_hash_operations
            hash_operation #(
                .index(i)
            )
            hash_operation_i(
            .clock(clock),           
            .a_in(con_a[i]),             
            .b_in(con_b[i]),             
            .c_in(con_c[i]),             
            .d_in(con_d[i]),             
            .message_in(con_message[i]), 
            .a_out(con_a[i+1]),           
            .b_out(con_b[i+1]),           
            .c_out(con_c[i+1]),           
            .d_out(con_d[i+1]),           
            .message_out(con_message[i+1])
            );           
        end
    endgenerate
        
 function[31:0] big_endian_32b;
	input[31:0] __IN;
	begin
		big_endian_32b = {__IN[0+:8],__IN[8+:8],__IN[16+:8],__IN[24+:8]};
	end
endfunction
        
    
  always@(posedge clock)
  begin
      if(enable) begin
          //Pre-processing: adding a single 1 bit
           message_padded = {message, 1'b1};
          //Pre-processing: padding with zeros
           message_padded = message_padded | 488'b0;
          //Pre-processing: Append length 2^64 
           message_padded =(message_length << 448)| message ;
           
          hash <= {big_endian_32b(con_a[64]+a_initial),
                   big_endian_32b(con_b[64]+b_initial),
                   big_endian_32b(con_c[64]+c_initial),
                   big_endian_32b(con_d[64]+d_initial)};
          message_out = con_message[64];
          
       end
   end
   
endmodule
