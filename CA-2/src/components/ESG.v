module ESG(PU0_zero , PU1_zero , PU2_zero , PU3_zero , end_signal);
    input [0:0] PU0_zero , PU1_zero , PU2_zero , PU3_zero;
    output [0:0] end_signal;

    wire [0:0] PU0_zero_inv , PU1_zero_inv , PU2_zero_inv , PU3_zero_inv , and1 , and2 , and3 , and4;

    E_INV #(1) inv1(PU0_zero, PU0_zero_inv);
    E_INV #(1) inv2(PU1_zero, PU1_zero_inv);
    E_INV #(1) inv3(PU2_zero, PU2_zero_inv);
    E_INV #(1) inv4(PU3_zero, PU3_zero_inv);

    E_AND #(4) a1({PU0_zero_inv , PU1_zero , PU2_zero , PU3_zero} , and1);
    E_AND #(4) a2({PU0_zero , PU1_zero_inv , PU2_zero , PU3_zero} , and2);
    E_AND #(4) a3({PU0_zero , PU1_zero , PU2_zero_inv , PU3_zero} , and3);
    E_AND #(4) a4({PU0_zero , PU1_zero , PU2_zero , PU3_zero_inv} , and4);

    E_OR #(4) o({and1 , and2 , and3 , and4} , end_signal);

endmodule
