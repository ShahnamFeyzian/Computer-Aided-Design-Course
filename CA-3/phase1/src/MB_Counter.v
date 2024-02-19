module MB_Counter(clk, rst, en, valOut, zero);

    input wire[0:0] clk, rst, en;

    output wire[0:0] zero;
    output reg[3:0] valOut;

    always @(posedge clk, posedge rst) begin
        if(rst) valOut <= 4'b0;
        else if(en) begin
            if(valOut == 4'd12) valOut <= 4'b0;
            else valOut <= valOut + 1;
        end
    end

    assign zero = (valOut == 0) ? 1'b1 : 1'b0;

endmodule
