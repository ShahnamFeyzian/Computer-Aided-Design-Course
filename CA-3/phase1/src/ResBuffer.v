module ResBuffer(clk, rst, en, clear, valIn, full, valOut);

    input wire[0:0] clk, rst, en, clear;
    input wire[7:0] valIn;

    output wire[0:0] full;
    output reg[7:0] valOut [0:3];

    reg[1:0] cnt;

    integer i;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            cnt <= 2'b0;
            for(i=0; i<4; i=i+1) begin
                valOut[i] <= 8'b0;
            end
        end
        else if(clear) begin
            for(i=0; i<4; i=i+1) begin
                valOut[i] <= 8'b0;
            end
        end
        else if(en) begin
            cnt <= cnt + 1;
            valOut[cnt] <= valIn;
        end
    end

    assign full = (cnt == 2'b11) ? 1'b1 : 1'b0;

endmodule
