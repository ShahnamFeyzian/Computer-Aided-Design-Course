`timescale 1ns/1ns

module ESG_TB();
    reg [0:0] PU0_zero = 1'b0;
    reg [0:0] PU1_zero = 1'b0;
    reg [0:0] PU2_zero = 1'b0;
    reg [0:0] PU3_zero = 1'b0;
    wire [0:0] end_signal;
    ESG esg(PU0_zero , PU1_zero , PU2_zero , PU3_zero , end_signal);
    initial begin
	#100 PU0_zero = 1;
	#100 PU1_zero = 1;
	#100 PU2_zero = 1;
	#100 $stop;
    end
    initial 
	$monitor($time , "PU0_zero = %b , PU1_zero = %b , PU2_zero = %b  , PU3_zero = %b  , end_signal = %b" , PU0_zero , PU1_zero , PU2_zero , PU3_zero , end_signal);
endmodule
