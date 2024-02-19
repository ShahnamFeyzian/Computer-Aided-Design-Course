module Multiplier(a, b, out);

    parameter N = 32;

    input wire signed [N-1:0] a, b;
    output wire[(2*N)-1:0] out;

    wire[N-1:0] abs_a, abs_b;
    Absolute #(N) abs1(.in(a), .out(abs_a));
    Absolute #(N) abs2(.in(b), .out(abs_b));

    wire[(2*N)-1:0] res_pos, res_neg;
    Array_Multiplier  #(N) mult(.a(abs_a), .b(abs_b), .out(res_pos));
    Twos_Complementor #(2*N) inv(.in(res_pos), .out(res_neg));

    wire[0:0] sign;
    C_XOR c_xor(.a(a[N-1]), .b(b[N-1]), .out(sign));

    E_MUX #(2*N) mux(.a00(res_pos), .a01(res_neg), .a10(1'bz), .a11(1'bz), .sel({1'b0, sign}), .out(out));

endmodule
