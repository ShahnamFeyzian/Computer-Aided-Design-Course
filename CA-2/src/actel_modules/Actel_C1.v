module Actel_C1(a0, a1, sa, b0, b1, sb, s0, s1, out);

    input wire[0:0] a0, a1, sa, b0, b1, sb, s0, s1;
    output wire[0:0] out; 

    wire[0:0] f1 = (sa) ? a1 : a0;
    wire[0:0] f2 = (sb) ? b1 : b0;    

    assign out = (s0 | s1) ? f2 : f1;

endmodule
