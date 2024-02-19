module Comparator(a, b, out);

    parameter N = 32;

    input wire[N-1:0] a, b;
    output wire[0:0] out;

    wire[N-1:0] midd_res;

    genvar i;
    generate
        for (i=0; i<N; i=i+1) begin
            C_XOR c_xor(.a(a[i]), .b(b[i]), .out(midd_res[i]));
        end
    endgenerate

    wire[0:0] final_res;
    E_OR #(N) e_or(.in(midd_res), .out(final_res));

    C_INV inv(.in(final_res), .out(out));

endmodule
