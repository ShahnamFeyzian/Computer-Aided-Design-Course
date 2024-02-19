module Absolute(in, out);

    parameter N = 32;

    input wire[N-1:0] in;
    output wire[N-1:0] out;

    wire[N-1:0] inverted;
    Twos_Complementor #(N) tc(.in(in), .out(inverted));

    wire[1:0] sel = {1'b0, in[N-1]};
    E_MUX #(N) mux(.a00(in), .a01(inverted), .a10(1'bz), .a11(1'bz), .sel(sel), .out(out));

endmodule
