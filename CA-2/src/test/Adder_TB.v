`timescale 1ns/1ns

module Adder_TB();
    parameter B = 12;

    reg[B-1:0] a, b;
    reg[0:0] cin;
    wire[B-1:0] s;
    wire[0:0] cout;

    Adder #(B) adder(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

    initial begin
        a = 12; b = 13; cin = 1'b0;
        #10 a = 0; b = 0;
        #10 a = 0; b = 1213;
        #10 a = 192; b = 0;
        #10 a = 232; b = -32;
        #10 a = -900; b = 1000;
        #10 a = 54; b = -54;
        #10 cin = 1'b1;
        #10 cin = 1'b0;
        #10 a = -232; b = -32;
        #10 a = {B{1'b1}}; b = 0;
        #10 cin = 1'b1;
        #10 $stop;
    end

endmodule
