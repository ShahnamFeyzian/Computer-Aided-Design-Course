`timescale 1ns/1ns

module Comparator_TB();

    parameter B = 5;

    reg[B-1:0] a, b;
    wire[0:0] out;

    Comparator #(B) cmp(.a(a), .b(b), .out(out));

    initial begin
        #5 a=5'b00000; b=5'b00000;
        #5 a=5'b01000; b=5'b00111;
        #5 a=5'b01001; b=5'b01001;
        #5 a=5'b11001; b=5'b00110;
        #5 a=5'b11111; b=5'b11111;
        #5 a=5'b01011; b=5'b01011;
        #5 a=5'b01011; b=5'b11011;
        #5 $stop;
    end

endmodule
