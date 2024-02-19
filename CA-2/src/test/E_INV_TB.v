`timescale 1ns/1ns

module E_INV_TB();

    parameter B = 5;

    reg[B-1:0] in;
    wire[B-1:0] out;

    E_INV #(B) inv(.in(in), .out(out));

    initial begin
        #5 in = 7'b1111111;
        #5 in = 7'b0110101;
        #5 in = 7'b0000000;
        #5 in = 7'b1010111;
        #5 in = 7'b1011001;
        #5 $stop;
    end

endmodule
