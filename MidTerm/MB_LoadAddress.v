module MB_LoadAddress(clk, rst, active, addrOut);

    input wire[0:0] clk, rst, active;

    output reg[1:0] addrOut;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
          addrOut <= 2'b0;
        end
        else if(active) begin
            addrOut <= addrOut + 1;
        end 
    end

endmodule
