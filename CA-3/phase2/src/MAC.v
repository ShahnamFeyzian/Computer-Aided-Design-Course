module MAC(clk, rst, active, clear, val1In, val2In, valOut);

    input wire[0:0] clk, rst, active, clear;
    input wire[7:0] val1In, val2In;

    output reg[31:0] valOut;

    wire[15:0] res = val1In * val2In;

    always @(posedge clk, posedge rst) begin
        if(rst)         valOut <= 12'b0;
        else if(clear)  valOut <= 12'b0;
        else if(active) valOut <= res[15:8] + valOut;
    end

endmodule
