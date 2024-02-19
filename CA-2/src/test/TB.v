`timescale 1ns/1ns

module TB();

    reg[0:0] clk=0, rst=1;
    reg[4:0] b0_in, b1_in, b2_in, b3_in;
    wire[0:0] done;
    wire[4:0] result;

    Toplevel toplevel(.clk(clk), .rst(rst), .b0_in(b0_in), .b1_in(b1_in), .b2_in(b2_in), .b3_in(b3_in),
                .done(done), .result(result));

    always #5 clk = ~clk;

    initial begin
        b0_in=5'b00011; b1_in=5'b00010; b2_in=5'b00001; b3_in=5'b00101;
        #10 rst = 1'b0;
        #1000 $stop;
    end

endmodule
