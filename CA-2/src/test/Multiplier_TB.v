`timescale 1ns/1ns

module Multiplier_TB();

    parameter B = 5;

    reg[B-1:0] a, b;
    wire[(2*B)-1:0] out;

    Multiplier #(B) mt(.a(a), .b(b), .out(out));

    initial begin
        a=0; b=0;
        #10 a=3; b=0;
        #10 a=0; b=2;
        #10 a=3; b=5;
        #10 a=7; b=-2;
        #10 a=-3; b=12;
        #10 a=-2; b=-9;
        #10 $stop;
    end

endmodule
