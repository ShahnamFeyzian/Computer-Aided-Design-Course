module C_INV(in, out);

    input wire[0:0] in;
    output wire[0:0] out;

    Actel_C2 c2(
        .out(out),
        .d00(1'b1), .d01(1'bz), 
        .d10(1'b0), .d11(1'bz), 
        .a1(in),    .b1(1'b0), 
        .a0(1'b0),  .b0(1'b0)
    );

endmodule
