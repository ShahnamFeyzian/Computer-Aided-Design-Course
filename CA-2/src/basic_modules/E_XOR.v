module E_XOR(in, out);

    parameter N = 32;

    input wire[N-1:0] in;
    output wire[0:0] out;

    wire[N-2:0] midd_res;
    C_XOR xor1(.a(in[0]), .b(in[1]), .out(midd_res[0]));

    genvar i;
    generate
        for (i=0; i<N-1; i=i+1) begin
            C_XOR c_xor(.a(in[i+2]), .b(midd_res[i]), .out(midd_res[i+1]));
        end
    endgenerate

    assign out = midd_res[N-2];

endmodule
