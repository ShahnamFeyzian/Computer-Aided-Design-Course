module E_MUX(a00, a01, a10, a11, sel, out);

    parameter N = 32;

    input wire[N-1:0] a00, a01, a10, a11;
    input wire[1:0] sel;
    output wire[N-1:0] out;

    genvar i;
    generate
        for (i=0; i<N; i=i+1) begin
            C_MUX mux(
                .a00(a00[i]), .a01(a01[i]), 
                .a10(a10[i]), .a11(a11[i]), 
                .sel(sel),    .out(out[i])
            );
        end
    endgenerate

endmodule
