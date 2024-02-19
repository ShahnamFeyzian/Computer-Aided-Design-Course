`timescale 1ns/1ns

module AF_TB();
    reg [11:0] Inn =12'b0001_1010_0101;
    wire [4:0] Outt;
    wire [0:0] Zero_signall;
    AF af(.In(Inn) , .Out(Outt) , .Zero_signal(Zero_signall));
    initial begin
	#100 Inn = 12'b1001_1010_0101;
	#100 $stop;
    end
    initial 
	$monitor($time , "Inn = %b , Outt = %b , Zero_signal = %b" , Inn , Outt , Zero_signall);
endmodule
