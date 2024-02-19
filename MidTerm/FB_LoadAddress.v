module FB_LoadAddress(clk, rst, active, valOut);

    input wire[0:0] clk, rst, active;

    output reg[1:0] valOut;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
          valOut <= 2'b0;
        end
        else if(active) begin
            valOut <= valOut + 1;
        end 
    end

endmodule
