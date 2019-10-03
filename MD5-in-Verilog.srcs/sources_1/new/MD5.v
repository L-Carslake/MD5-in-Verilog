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
    input wire [63:0]  message_length, //bits
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
    
    genvar i;
    generate //Processing: Generate the 64 MD5 stages in a pipeline
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

function[447:0] to_c_string; //Convert verilog string to a C format string arrangement
    input[447:0] __STRING;
    input[64:0] __LENGTH;
    reg[4:0] itterations;
    reg[4:0] index;
    reg[5:0] remainder;
    reg[5:0] j;
    begin
        $display("function: to_c_string");
        
        $display("  itteratons: %2d", __LENGTH /32 );
        itterations = __LENGTH / 32 ;
        remainder = __LENGTH % 32 ;
        to_c_string = 448'b0;
        
        for(index =0; index<itterations ; index=index+1) begin //rearrange full 32bit words
            $display("  index: %1d value: %h",  index, big_endian_32b(__STRING[(__LENGTH -32 * (index+1)) +: 32]));
            to_c_string[(index*32)%415 +: 32] = big_endian_32b(__STRING[(__LENGTH -32 * (index+1)) +: 32]);
        end
        for(j = 0 ; j < remainder < 32; j = j +8 )begin //rearrange partial last word
            $display("  remianing: %1d bits value: %h",  remainder-j , __STRING[remainder -j -8 +: 8]);
            to_c_string[(index*32 + j) +: 8] = __STRING[remainder -j -8 +: 8];
        end
        $display("endfunction: to_c_string\n");
    end
endfunction

  always@(posedge clock)
  begin
      if(enable) begin
          //Pre-processing: Append length 2^64 
          message_padded = {
          message_length[63:0],
          to_c_string(message, message_length)};
          //Pre-processing: append a single 1 
          message_padded[(message_length)+:32] = 'h00000080;
          //Pre-processing: padding with zeros
          // message_padded = message_padded | 488'b0;
          
          //Output: Combine the four segments
          hash <= {big_endian_32b(con_a[64]+a_initial),
                   big_endian_32b(con_b[64]+b_initial),
                   big_endian_32b(con_c[64]+c_initial),
                   big_endian_32b(con_d[64]+d_initial)};
          //output: Repeat the input message
          message_out = con_message[64];
          
       end
   end
   
endmodule
