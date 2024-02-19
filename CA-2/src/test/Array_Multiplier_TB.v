`timescale 1ns/1ns

module Array_Multiplier_TB();

    parameter B = 8;

    reg[B-1:0] a, b;
    wire[(2*B)-1:0] out;

    Multiplier #(B) mt(.a(a), .b(b), .out(out));

    initial begin
        a=0; b=0;
        #10 a=3; b=0;
        #10 a=0; b=2;
        #10 a=3; b=5;
        #10 a=7; b=23;
        #10 a=112; b=12;
        #10 a=90; b=89;
        #10 $stop;
    end

endmodule
