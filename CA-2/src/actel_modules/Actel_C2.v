module Actel_C2(d00, d01, d10, d11, a1, b1, a0, b0, out);

    input wire[0:0] d00, d01, d10, d11, a1, b1, a0, b0;
    output reg[0:0] out;

    wire[0:0] s0 = a0 & b0;
    wire[0:0] s1 = a1 | b1;
    wire[1:0] sel = {s1, s0};

    always @(*) begin
        case(sel)
            2'b00 : out = d00;
            2'b01 : out = d01;
            2'b10 : out = d10;
            2'b11 : out = d11;
        endcase
    end

endmodule
