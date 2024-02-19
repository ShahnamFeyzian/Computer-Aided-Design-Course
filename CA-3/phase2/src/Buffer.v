module Buffer(clk, rst, shiftUp, shiftLeft, wrEn, idxI, idxJ, dataIn, dataOut);

    parameter SIZE = 4;

    input wire[0:0]  clk, rst, shiftUp, shiftLeft, wrEn;
    input wire[7:0]  dataIn;
    input wire[31:0] idxI, idxJ;
    output wire[7:0] dataOut;

    reg[7:0] internal_reg [0:SIZE-1][0:SIZE-1];

    integer i, j;
    always @(posedge clk, posedge rst) begin
        
        if(rst) begin
            for(i=0; i<SIZE; i=i+1) 
                for(j=0; j<SIZE; j=j+1)
                    internal_reg[i][j] <= 8'b0;
        end

        else if(shiftUp) begin
            for(i=1; i<SIZE; i=i+1)
                for(j=0; j<SIZE; j=j+1)
                    internal_reg[i-1][j] <= internal_reg[i][j];
        end

        else if(shiftLeft) begin
            for(j=1; j<SIZE; j=j+1)
                for(i=0; i<SIZE; i=i+1)
                    internal_reg[i][j-1] <= internal_reg[i][j];
        end

        else if(wrEn) begin
            internal_reg[idxI][idxJ] <= dataIn;
        end

    end

    assign dataOut = internal_reg[idxI][idxJ];

endmodule
