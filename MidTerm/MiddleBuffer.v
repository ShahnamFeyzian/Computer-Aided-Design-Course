module MiddleBuffer(clk, rst, shiftEn, writeEn, writeIndex, readIndex, dataIn, dataOut);

    input wire[0:0] clk, rst, writeEn, shiftEn;
    input wire[1:0] writeIndex;
    input wire[3:0] readIndex;
    input wire[31:0] dataIn;

    output reg[7:0] dataOut [0:15];

    reg[7:0] internal_regs [0:63];
    // wire[3:0] mid_i = iIndex<<2;
    // wire[3:0] final_index = mid_i + jIndex;

    integer i, j;
    always @(posedge clk, posedge rst) begin // sequential always
        if(rst) begin
            for(i=0; i<64; i=i+1) begin
                internal_regs[i] <= 8'b0;
            end
        end
        else if(writeEn) begin
            internal_regs[(writeIndex<<2)+48] <= dataIn[7:0];
            internal_regs[(writeIndex<<2)+49] <= dataIn[15:8];
            internal_regs[(writeIndex<<2)+50] <= dataIn[23:16];
            internal_regs[(writeIndex<<2)+51] <= dataIn[31:24];
        end
        else if(shiftEn) begin
            for(i=16; i<64; i=i+1) begin
                internal_regs[i-16] <= internal_regs[i];
            end
        end
    end

    always @(*) begin // combinational always
        for(i=0; i<4; i=i+1) begin
            for(j=0; j<4; j=j+1) begin
                dataOut[(i*4) + j] <= internal_regs[readIndex+(i*16) + j];
            end
        end
    end

endmodule
