module Twos_Complementor(in, out);

    parameter N = 32;

    input wire[N-1:0] in;
    output wire[N-1:0] out;

    wire[N-1:0] inverted_in;
    E_INV #(N) inv(.in(in), .out(inverted_in));

    Adder #(N) adder(.a(inverted_in), .b({N{1'b0}}), .cin(1'b1), .s(out));

endmodule
