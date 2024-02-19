module Memory(clk, rEn, wEn, dataIn, addrIn, dataOut);

    input wire[0:0] clk, rEn, wEn;
    input wire[31:0] addrIn;
    input wire[7:0] dataIn [0:3];
    
    output wire[31:0] dataOut;

    wire[31:0] addr = addrIn;

    reg[31:0] mem [0:127];
    wire[31:0] temp_data_in = {dataIn[0], dataIn[1], dataIn[2], dataIn[3]};

    integer i;
    initial begin
        $readmemh("test1234.txt", mem);
    end

    always @(posedge clk) begin
        if(wEn) begin
            mem[addr] <= temp_data_in;
        end
    end

    assign dataOut = (rEn) ? { mem[addr][7:0], mem[addr][15:8], mem[addr][23:16], mem[addr][31:24]} : 32'bz;

endmodule
