module C_AND(a, b, out);

    input wire[0:0] a, b;
    output wire[0:0] out;

    Actel_C2 c2(
        .out(out),
        .d00(1'b0), .d01(1'b1), 
        .d10(1'bz), .d11(1'bz), 
        .a1(1'b0),  .b1(1'b0), 
        .a0(a),     .b0(b) 
    );

endmodule
