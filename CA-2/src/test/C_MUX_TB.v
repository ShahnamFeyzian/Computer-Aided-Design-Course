`timescale 1ns/1ns

module C_MUX_TB();

    reg[1:0] sel;
    wire[0:0] out;

    C_MUX mux(.a00(1'b0), .a01(1'b1), .a10(1'bz), .a11(1'bx), .sel(sel), .out(out));

    initial begin
        sel    = 2'b00;
        #5 sel = 2'b01;
        #5 sel = 2'b10;
        #5 sel = 2'b11;
        #5 $stop;
    end

endmodule
