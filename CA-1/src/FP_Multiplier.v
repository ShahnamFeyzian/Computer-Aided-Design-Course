module FP_Multiplier(a, b, p);
    input [31:0] a, b;
    output [31:0] p;

    wire [23:0] aFrac = {1'b1 , a[22:0]};
    wire [23:0] bFrac = {1'b1 , b[22:0]};
    wire [47:0] midFrac = aFrac * bFrac;
    wire [7:0] midExp = a[30:23] + b[30:23] - 8'b 01111111;


    wire [7:0] resExp = midExp + midFrac[47];
    wire [22:0] resFrac = (midFrac[47]) ? midFrac[46:24] : midFrac[45:23];
    wire [0:0] sign = a[31] ^ b[31];
    assign p = (a == 32'b0 || b == 32'b0) ? 32'b0 : {sign , resExp , resFrac};

endmodule
