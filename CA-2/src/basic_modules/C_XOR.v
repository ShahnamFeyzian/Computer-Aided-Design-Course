module C_XOR(a, b, out);

    input wire[0:0] a, b;
    output wire[0:0] out;

    C_MUX mux(.a00(1'b0), .a01(1'b1), .a10(1'b1), .a11(1'b0), .sel({a, b}), .out(out));

endmodule
