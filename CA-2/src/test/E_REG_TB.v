`timescale 1ns/1ns

module E_REG_TB();

    parameter B = 18;

    reg[0:0] clk, rst, en;
    reg[B-1:0] in;
    wire[B-1:0] out;

    E_REG #(B) s_reg(.clk(clk), .rst(rst), .en(en), .in(in), .out(out));

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        en  = 1'b0;
        in  = 12;

        #17 rst = 1'b1;
        #12 rst = 1'b0;

        #25 en = 1'b1;
        #10 in = 27;
        #10 in = 192;

        #25 rst = 1'b1;

        #25 $stop;

    end

endmodule
