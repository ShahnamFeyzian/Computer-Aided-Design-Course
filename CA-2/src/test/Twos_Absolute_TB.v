`timescale 1ns/1ns

module Twos_Complementor_TB();

    parameter B = 12;
    reg[B-1:0] in;
    wire[B-1:0] twos_out, abs_out;

    Twos_Complementor #(B) tc(.in(in), .out(twos_out));
    Absolute #(B) abs(.in(in), .out(abs_out));

    initial begin
        #10 in = 12;
        #10 in = 1263;
        #10 in = -83;
        #10 in = -12;
        #10 in = 1201;
        #10 in = -90;
        #10 in = 0;
        #10 $stop;
    end

endmodule
