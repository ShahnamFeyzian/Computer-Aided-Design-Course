`timescale 1ns/1ns

module TopLevel_TB();

    reg[0:0] clk, rst;
    wire[0:0] done;
    wire[31:0] res;

    TopLevel topLevel(.clk(clk), .rst(rst), .done(done), .result(res));


    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;

        #20 rst = 1;
        #20 rst = 0;

        #2000 $stop;

    end

endmodule