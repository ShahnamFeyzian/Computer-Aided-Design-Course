`timescale 1ns/1ns

module C_Gates_TB();

    reg[0:0] a, b;
    wire[0:0] and_out, or_out, xor_out;

    C_AND c_and(.a(a), .b(b), .out(and_out));
    C_OR  c_or(.a(a), .b(b), .out(or_out));
    C_XOR c_xor(.a(a), .b(b), .out(xor_out));

    initial begin
        a = 1'b0; b = 1'b0;
        #5 a = 1'b1; b = 1'b0;
        #5 a = 1'b0; b = 1'b1;
        #5 a = 1'b1; b = 1'b1;
        #5 $stop;
    end


endmodule
