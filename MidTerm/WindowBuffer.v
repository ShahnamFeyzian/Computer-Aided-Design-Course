module WindowBuffer(clk, rst, ld, iIndex, jIndex, dataIn, dataOut);

    input wire[0:0] clk, rst, ld;
    input wire[1:0] iIndex, jIndex;
    input wire[7:0] dataIn [0:15];

    output wire[7:0] dataOut;

    wire[3:0] final_index = {iIndex, jIndex};
    reg[7:0] internal_regs [0:15];

    integer i;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            for(i=0; i<16; i=i+1) begin
                internal_regs[i] <= 8'b0;
            end
        end
        else if(ld) begin
            for(i=0; i<16; i=i+1) begin
                internal_regs[i] <= dataIn[i];
            end
        end
    end

    assign dataOut = internal_regs[final_index];

endmodule
