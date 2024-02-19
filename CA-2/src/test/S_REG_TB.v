`timescale 1ns/1ns

module S_REG_TB();

    reg[0:0] clk, rst, en, in;
    wire[0:0] out;

    S_REG s_reg(.clk(clk), .rst(rst), .en(en), .in(in), .out(out));

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        en  = 1'b0;
        in  = 1'b1;

        #17 rst = 1'b1;
        #12 rst = 1'b0;

        #25 en = 1'b1;
        #10 in = 1'b0;
        #10 in = 1'b1;

        #25 rst = 1'b1;

        #25 $stop;

    end

endmodule
