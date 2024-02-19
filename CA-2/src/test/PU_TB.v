`timescale 1ns/1ns

module PU_TB();
    reg [4:0] x0 , x1 , x2 ,x3 , w0 , w1 , w2 , w3;
    reg [0:0] mult_reg_en = 1'b0;
    reg [0:0] add_reg_en = 1'b0;
    reg [0:0] clk = 1'b0;
    wire [4:0] new_value;
    wire [0:0] Zero_signal;
    PU pu(x0 , x1 , x2 , x3 , w0 , w1 , w2 , w3 , mult_reg_en , add_reg_en , Zero_signal , new_value , clk );
    always
	#5 clk = ~ clk;
    initial begin
	     x0 = 5'b00010; //0.25
	     x1 = 5'b11100; //-0.5
	     x2 = 5'b00100; //0.5
    	 x3 = 5'b00110; //0.75
	     w0 = 5'b00010; //0.25
	     w1 = 5'b00010; //0.25
	     w2 = 5'b00010; //0.25
	     w3 = 5'b00010; //0.25
	     // result : 0.25
	#13 mult_reg_en = 1'b1;
	#10 mult_reg_en = 1'b0; add_reg_en = 1'b1;
	#10 mult_reg_en = 1'b0; add_reg_en = 1'b0;
		
	#100 
	     x1 = 5'b00000; //0
	     // result : 0.375 => 00011
	#13 mult_reg_en = 1'b1;
	#10 mult_reg_en = 1'b0; add_reg_en = 1'b1;
	#10 mult_reg_en = 1'b0; add_reg_en = 1'b0;
	#100 $stop;
    end
    initial 
	$monitor($time , "new_value = %b , Zero_signal = %b" , new_value , Zero_signal);
endmodule
