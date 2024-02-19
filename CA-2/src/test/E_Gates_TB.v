`timescale 1ns/1ns

module E_Gates_TB();

    parameter B = 5;

    reg[B-1:0] a;
    wire[0:0] and_out, or_out, xor_out;

    E_AND #(B) c_and(.in(a), .out(and_out));
    E_OR  #(B) c_or (.in(a), .out(or_out));
    E_XOR #(B) c_xor(.in(a), .out(xor_out));

    initial begin
        #5 a = 5'b00000;
        #5 a = 5'b11111;
        #5 a = 5'b01010;
        #5 a = 5'b10011;
        #5 a = 5'b00010;
        #5 a = 5'b11011;
        #5 $stop;
    end


endmodule
