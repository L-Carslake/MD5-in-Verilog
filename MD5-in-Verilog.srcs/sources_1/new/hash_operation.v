`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 26.09.2019 14:42:26
// Design Name:
// Module Name: hash_operation
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
module hash_operation(
        input wire clock,
        input wire[31:0] a_in, b_in, c_in, d_in,
        input wire[511:0] message_in,

        output reg[31:0] a_out, b_out, c_out, d_out,
        output reg[511:0] message_out
    );

    parameter index = 0;
    reg[31:0] per_round_shift_amounts [0:63], sines_of_integers [0:63];
    reg[31:0] message_debug,  f_debug, pre_shift_debug, post_shift_debug;

    //Function: Auxiliary function F
    // Takes three 32-bit words and produce as output one 32-bit word.
    //> F(X,Y,Z) = XY v not(X) Z
    function [31:0] F;
        input[31:0] B, C, D;
        begin
            F = (B&C) | ((~B)&D);
        end
    endfunction

    //Function: Auxiliary function G
    // Takes three 32-bit words and produce as output one 32-bit word.
    // > G(X,Y,Z) = XZ v Y not(Z)
    function[31:0] G;
        input[31:0] B, C, D;
        begin
            G = (B&D) | ((~D)&C);
        end
    endfunction

    //Function: Auxiliary function H
    // Takes three 32-bit words and produce as output one 32-bit word.
    //> H(X,Y,Z) = X xor Y xor Z
    function[31:0] H;
        input[31:0] B, C, D;
        begin
            H = B^C^D;
        end
    endfunction

    // Function: Auxiliary function I
    // Takes three 32-bit words and produce as output one 32-bit word.
    //> I(X,Y,Z) = Y xor (X v not(Z))
    function[31:0] I;
        input[31:0] B, C, D;
        begin
            I = C^(B|(~D));
        end
    endfunction

    /*Function: Switch Endianess
     Switch the endianess of a 32bit word in multiples of 8 bits.
    */
    function[31:0] switch_endianness_32b;
        input[31:0] _in;
        begin
            switch_endianness_32b = {_in[0+:8], _in[8+:8], _in[16+:8], _in[24+:8]};
        end
    endfunction

    /* Function: Circular Shift
    Shift the input 32-bit word left by the required number of places.

    Paremeters:

    in - input 32 bit words.
    shift_amount - Amount to shift word by.

    Returns:

    The shifted 32-bit word.
    */
    function[31:0] shift_circ;
        input[31:0] in;
        input [31:0] shift_amount;
        begin
            shift_circ = (in<<shift_amount) | (in>>(32-shift_amount));
        end
    endfunction

    initial begin
        $readmemh("per-shift-amounts.mem", per_round_shift_amounts);
        $readmemh("sines-of-integers.mem", sines_of_integers);
    end

/*Function: Auxillary Function Switch Case
Implements the correct auxiliary function as required by the index.

Returns:

 a, b, c, d - for the next index of the MD5 process

*/
    always@(posedge clock)
    begin
        case (index/16)
            0:begin b_out <= b_in + shift_circ( ( a_in + F(b_in, c_in, d_in) + (message_in[32*((index))  +: 32]) + sines_of_integers[index]) , per_round_shift_amounts[index]);
            message_debug <= (message_in[32*((index))  +: 32]); end
            1: begin b_out <= b_in + shift_circ( ( a_in + G(b_in, c_in, d_in) + (message_in[32*((5*index+1)%16)  +: 32]) + sines_of_integers[index]) , per_round_shift_amounts[index]);
            message_debug <= (message_in[32*((5*index+1)%16)  +: 32]); end
            2: begin b_out <= b_in + shift_circ( ( a_in + H(b_in, c_in, d_in) + (message_in[32*((3*index+5)%16)  +: 32]) + sines_of_integers[index]) , per_round_shift_amounts[index]);
            message_debug <= (message_in[32*((3*index+5)%16)  +: 32]); end
            3:begin b_out <= b_in + shift_circ( ( a_in + I(b_in, c_in, d_in) + (message_in[32*((7*(index))%16)    +: 32]) + sines_of_integers[index]) , per_round_shift_amounts[index]);
            message_debug <= (message_in[32*((7*(index))%16)    +: 32]); end
        endcase
        f_debug <= F(b_in, c_in, d_in);
        //pre_shift_debug <= ( a_in + F(b_in, c_in, d_in) + (message_in[32*((index))  +: 32]) + sines_of_integers[index]);
        //post_shift_debug <= shift_circ( ( a_in + F(b_in, c_in, d_in) + (message_in[32*((index))  +: 32]) + sines_of_integers[index]) , per_round_shift_amounts[index]);
        d_out <= c_in;
        c_out <= b_in;
        a_out <= d_in;
        message_out <= message_in;
    end

endmodule
