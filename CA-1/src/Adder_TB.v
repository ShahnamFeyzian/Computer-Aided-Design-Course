`timescale 1ns/1ns

module Adder_TB();

    reg [31:0] a, b;
    wire[31:0] out_add, out_mul;

    FP_Adder adder(.val1(a), .val2(b), .val_out(out_add));
    FP_Multiplier mul(.a(a), .b(b), .p(out_mul));

    initial begin
        a = 32'b01000010000010000000000000000000; // 34
        b = 32'b01000010110000000000000000000000; // 96
                                                  // res = 01000011000000100000000000000000

        #20 a = 32'b11000100010001010100000000000000; // -789
        b = 32'b01000100000000000000000000000000; // 512
                                                       // res = 11000100000100000100000000000000

        #20 a = 32'b01000101101100010100000011110110; // 5672.1201171875
        b = 32'b01000100001111001011100110011010; // 754.9000244140625
                                                      // res = 01000101110010001101100000101001

        #20 a = 32'b01000101100011101101111100101011; // 4571.89599609375
        b = 32'b11000110000011011011111110010110; // -9071.896484375
                                                      // res = 11000101100011001010000000000001

        #20 a = 32'b00000000000000000000000000000000; // 0
        b = 32'b01001100110110111101110000110001; // 115270024
                                                      // res = 01001100110110111101110000110001

        #20 a = 32'b11001100110110111101110000110001; // -115270024
        b = 32'b00000000000000000000000000000000; // 0
                                                      // res = 11001100110110111101110000110001

        #20 a = 32'b01000110000010111000111111110010; // 8931.986328125
        b = 32'b11000110000010111000111111110010; // -8931.986328125
                                                      // res = 0

        #20 a = 32'b01000110000010110100010011101100;
        b = 32'b11000110000010110100010011101101;

	#20 $stop;
    end

endmodule