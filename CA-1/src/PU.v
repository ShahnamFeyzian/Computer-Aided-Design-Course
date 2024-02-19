module PU(x0 , x1 , x2 , x3 , w0 , w1 , w2 , w3 , mult_reg_en , add_reg_en , Zero_signal , new_value , clk);
    input [31:0] x0 , x1 , x2 , x3 , w0 , w1 , w2 , w3;
    input [0:0] mult_reg_en , add_reg_en , clk;
    output [31:0] new_value;
    output [0:0] Zero_signal;

    reg [31:0] x0w0 , x1w1 , x2w2 , x3w3;
    wire [31:0] wx0w0 , wx1w1 , wx2w2 , wx3w3;
    parameter NEXP = 8;
    parameter NSIG = 23;
    
    FP_Multiplier inst1(.a(x0),.b(w0),.p(wx0w0));
    FP_Multiplier inst2(.a(x1),.b(w1),.p(wx1w1));
    FP_Multiplier inst3(.a(x2),.b(w2),.p(wx2w2));
    FP_Multiplier inst4(.a(x3),.b(w3),.p(wx3w3));
    always @(posedge clk) begin
	if (mult_reg_en == 1'b1) begin
	x0w0 <= wx0w0;
	x1w1 <= wx1w1;
	x2w2 <= wx2w2;
	x3w3 <= wx3w3;
	end
    end
    wire [31:0] x0w0_add_x1w1 , x2w2_add_x3w3 , wadd_all;
    reg [31:0] add_all;
    FP_Adder dut(.val1(x0w0) , .val2(x1w1) ,.val_out(x0w0_add_x1w1));
    FP_Adder dut2(.val1(x2w2) , .val2(x3w3) ,.val_out(x2w2_add_x3w3));
    FP_Adder dut3(.val1(x0w0_add_x1w1) , .val2(x2w2_add_x3w3) ,.val_out(wadd_all));
    always @(posedge clk) begin
	if (add_reg_en == 1'b1) begin
	add_all <= wadd_all;
	end
    end

    AF af(.In(add_all) , .Out(new_value) , .Zero_signal(Zero_signal));
endmodule
