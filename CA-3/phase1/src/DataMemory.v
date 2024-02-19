module DataMemory(clk, rEn, wEn, dataIn, addrIn, dataOut);

    input wire[0:0] clk, rEn, wEn;
    input wire[31:0] addrIn;
    input wire[31:0] dataIn;
    
    output wire[31:0] dataOut;

    reg[31:0] mem [0:127];

    initial begin
        $readmemh("test1234.txt", mem);
    end

    always @(posedge clk) begin
        if(wEn) begin
            mem[addrIn] <= dataIn;
        end
    end

    assign dataOut = (rEn) ? {mem[addrIn][7:0], mem[addrIn][15:8], mem[addrIn][23:16], mem[addrIn][31:24]} : 32'bz;

endmodule
