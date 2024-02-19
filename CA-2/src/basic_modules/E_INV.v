module E_INV(in, out);

    parameter N = 32;

    input wire[N-1:0] in;
    output wire[N-1:0] out;

    genvar i;
    generate
        for(i=0; i<N; i=i+1) begin
            C_INV c_inv(.in(in[i]), .out(out[i]));
        end
    endgenerate

endmodule
