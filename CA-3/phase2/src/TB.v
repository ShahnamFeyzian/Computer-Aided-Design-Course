`timescale 1ns/1ns

module TB();

    reg[0:0] clk, rst;
    wire[0:0] done;
    always #5 clk = ~clk;


    Toplevel #(.X(16), .Y(0), .Z(16), .M(0)) 
    toplevel(
        .clk(clk),
        .rst(rst),
        .done(done)
    );

    initial begin
        rst = 1'b1;
        clk = 1'b0;

        #10 rst = 1'b0;

         #150000 $stop;
    end

endmodule
