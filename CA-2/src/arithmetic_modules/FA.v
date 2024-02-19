module FA(a, b, cin, s, cout);

    input wire[0:0] a, b, cin;
    output wire[0:0] s, cout;

    wire[0:0] a_xor_b;
    C_XOR xor1(.a(a), .b(b), .out(a_xor_b));
    C_XOR xor2(.a(a_xor_b), .b(cin), .out(s));

    wire[0:0] a_xor_b_and_cin, a_and_b;
    C_AND and1(.a(a_xor_b), .b(cin), .out(a_xor_b_and_cin));
    C_AND and2(.a(a), .b(b), .out(a_and_b));

    C_OR or1(.a(a_and_b), .b(a_xor_b_and_cin), .out(cout));

endmodule
