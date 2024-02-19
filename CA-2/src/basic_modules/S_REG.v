module S_REG(clk, rst, en, in, out);

    input wire[0:0] clk, rst, en, in;
    output wire[0:0] out;

    wire[0:0] s_out;

    Actel_S2 s2(
        .out(s_out),
        .d00(s_out), .d01(1'bz), 
        .d10(in),    .d11(1'bz), 
        .a1(en),     .b1(1'b0), 
        .a0(1'b0),   .b0(1'b0), 
        .clr(rst),   .clk(clk) 
    );

    assign out = s_out; 

endmodule
