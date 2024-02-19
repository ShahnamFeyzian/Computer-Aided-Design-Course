module Adder(dataIn, dataOut);

    parameter N = 1;

    input wire[31:0] dataIn [0:N-1];
    output reg[31:0] dataOut;

    integer i;
    always @(*) begin
        dataOut = 32'b0;
        for(i=0; i<N; i=i+1) begin
            dataOut = dataOut + dataIn[i];
        end
    end

endmodule
