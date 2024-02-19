module AF(In , Out , Zero_signal);
    input [31:0] In;
    output reg [31:0] Out;
    output reg [0:0] Zero_signal;


    always @(In) begin
	if(In[31] == 1'b1) Out = 32'b0;
	else Out = In;
	Zero_signal = In[31];
    end
endmodule