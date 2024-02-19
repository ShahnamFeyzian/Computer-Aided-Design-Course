module MAC(clk, rst, active, clear, val1In, val2In, valOut);

    input wire[0:0] clk, rst, active, clear;
    input wire[7:0] val1In, val2In;

    output wire[7:0] valOut;

    reg[11:0] temp_add;

    wire[15:0] res = val1In * val2In;

    always @(posedge clk, posedge rst) begin
        if(rst) temp_add <= 12'b0;
        else if(clear) temp_add <= 12'b0;
        else if(active) temp_add <= res[15:8] + temp_add;
    end

    assign valOut = temp_add[11:4];

endmodule
