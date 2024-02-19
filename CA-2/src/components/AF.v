module AF(In , Out , Zero_signal);
    input [11:0] In;
    output [4:0] Out;
    output  [0:0] Zero_signal;

    wire [11:0] inner_out;
    E_MUX #(12) mux(In , In, 12'b0 , 12'b0 , In[11:10], inner_out);
    assign Out = {inner_out[11] , inner_out[6] , inner_out[5:3]};
    assign Zero_signal = In[11];
endmodule