module C_OR(a, b, out);

    input wire[0:0] a, b;
    output wire[0:0] out;

    Actel_C2 c2(
        .out(out),
        .d00(1'b0), .d01(1'bz), 
        .d10(1'b1), .d11(1'bz), 
        .a1(a),     .b1(b), 
        .a0(1'b0),  .b0(1'b0)
    );

endmodule
