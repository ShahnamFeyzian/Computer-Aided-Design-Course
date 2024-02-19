module Adder(a, b, cin, s, cout);

    parameter N = 32;

    input wire[N-1:0] a, b;
    input wire[0:0] cin;
    output wire[N-1:0] s;
    output wire[0:0] cout;

    wire[0:0] c [0:N];
    assign c[0] = cin;

    genvar i;
    generate
        for(i = 0; i < N; i = i + 1) begin
          FA fa(.a(a[i]), .b(b[i]), .cin(c[i]), .s(s[i]), .cout(c[i+1]));
        end
    endgenerate

    assign cout = c[N];

endmodule
