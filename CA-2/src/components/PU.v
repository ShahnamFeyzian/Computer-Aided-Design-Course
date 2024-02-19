module PU(x0 , x1 , x2 , x3 , w0 , w1 , w2 , w3 , mult_reg_en , add_reg_en , Zero_signal , new_value , clk);
    input [4:0] x0 , x1 , x2 , x3 , w0 , w1 , w2 , w3;
    input [0:0] mult_reg_en , add_reg_en , clk;
    output [4:0] new_value;
    output [0:0] Zero_signal;

    wire [9:0] x0w0 , x1w1 , x2w2 , x3w3;
    wire [9:0] wx0w0 , wx1w1 , wx2w2 , wx3w3;
    
    Multiplier #(5) m1(.a(x0),.b(w0),.out(wx0w0));
    Multiplier #(5) m2(.a(x1),.b(w1),.out(wx1w1));
    Multiplier #(5) m3(.a(x2),.b(w2),.out(wx2w2));
    Multiplier #(5) m4(.a(x3),.b(w3),.out(wx3w3));

    E_REG #(10) mult_reg1(clk, 1'b0 , mult_reg_en, wx0w0, x0w0);
    E_REG #(10) mult_reg2(clk, 1'b0 , mult_reg_en, wx1w1, x1w1);
    E_REG #(10) mult_reg3(clk, 1'b0 , mult_reg_en, wx2w2, x2w2);
    E_REG #(10) mult_reg4(clk, 1'b0 , mult_reg_en, wx3w3, x3w3);
    
    wire [11:0] x0w0_add_x1w1 , x2w2_add_x3w3;
    wire [11:0] add_all , wadd_all;

    Adder #(12) ad1(.a({x0w0[9], x0w0[9], x0w0}) , .b({x1w1[9], x1w1[9], x1w1}) , .cin(1'b0) , .s(x0w0_add_x1w1));
    Adder #(12) ad2(.a({x2w2[9], x2w2[9], x2w2}) , .b({x3w3[9], x3w3[9], x3w3}) , .cin(1'b0) , .s(x2w2_add_x3w3));

    Adder #(12) ad3(.a(x0w0_add_x1w1) , .b(x2w2_add_x3w3) , .cin(1'b0) , .s(wadd_all));

    E_REG #(12) add_reg(clk, 1'b0 , add_reg_en, wadd_all, add_all);

    AF af(.In(add_all) , .Out(new_value) , .Zero_signal(Zero_signal));
endmodule
