module ESG(PU0_zero , PU1_zero , PU2_zero , PU3_zero , end_signal);
    input [0:0] PU0_zero , PU1_zero , PU2_zero , PU3_zero;
    output [0:0] end_signal;

    assign end_signal = ((~PU0_zero) & PU1_zero & PU2_zero & PU3_zero) | ((~PU1_zero) & PU0_zero & PU2_zero & PU3_zero) 
               | ((~PU2_zero) & PU1_zero & PU0_zero & PU3_zero) | ((~PU3_zero) & PU1_zero & PU2_zero & PU0_zero);
endmodule
