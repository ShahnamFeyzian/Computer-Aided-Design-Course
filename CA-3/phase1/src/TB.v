`timescale 1ns/1ns

module TB();

    reg clk, rst;
    wire done;

    TopLevel #(4) topLevel(.clk(clk), .rst(rst), .done(done));

    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        rst = 1'b1;
        #20 rst = 1'b0;
        #50000 $stop;
    end


endmodule