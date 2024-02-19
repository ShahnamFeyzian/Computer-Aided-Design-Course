module FilterBuffer(clk, rst, ldEn, iIndex, jIndex, dataIn, dataOut);

    input wire[0:0] clk, rst, ldEn;
    input wire[1:0] iIndex, jIndex;
    input wire[31:0] dataIn;

    output reg[7:0] dataOut;

    reg[7:0] internal_regs [0:15];
    wire[3:0] mid_i = iIndex<<2;
    wire[3:0] final_index = mid_i + jIndex;

    integer i;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            for(i=0; i<16; i=i+1) begin
                internal_regs[i] <= 8'b0;
            end
        end
        else if(ldEn) begin
            internal_regs[mid_i]       <= dataIn[7:0];
            internal_regs[mid_i+32'd1] <= dataIn[15:8];
            internal_regs[mid_i+32'd2] <= dataIn[23:16];
            internal_regs[mid_i+32'd3] <= dataIn[31:24];
        end
    end

    assign dataOut = internal_regs[final_index]; 

endmodule