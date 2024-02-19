module C_MUX(a00, a01, a10, a11, sel, out);

    input wire[0:0] a00, a01, a10, a11;
    input wire[1:0] sel;
    output wire[0:0] out;

    Actel_C2 c2(
        .out(out),
        .d00(a00),   .d01(a01), 
        .d10(a10),   .d11(a11), 
        .a1(sel[1]), .b1(1'b0), 
        .a0(sel[0]), .b0(1'b1)
    );

endmodule
