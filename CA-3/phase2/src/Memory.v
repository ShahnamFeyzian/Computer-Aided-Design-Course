module Memory(clk, rEn, wEn, dataIn, addrIn, dataOut);

    parameter TYPE=0, READ_ADDR=0;

    input wire[0:0] clk, rEn, wEn;
    input wire[7:0] dataIn;
    input wire[31:0] addrIn;
    
    output wire[7:0] dataOut;

    reg[31:0] mem [0:511];

    wire[1:0]  word_addr =  {addrIn[1], addrIn[0]};
    wire[31:0] row_addr = addrIn>>2; 
    wire[31:0] row = mem[row_addr];

    integer i;
    initial begin
        if(TYPE == 1) begin
            $readmemh("../datatest/filter1_L2.txt", mem, READ_ADDR);
        end
        else if(TYPE == 2) begin
            $readmemh("../datatest/filter2_L2.txt", mem, READ_ADDR);
        end 
        else if(TYPE == 3) begin
            $readmemh("../datatest/filter3_L2.txt", mem, READ_ADDR);
        end 
        else if(TYPE == 4) begin
            $readmemh("../datatest/filter4_L2.txt", mem, READ_ADDR);
        end 
        else if(TYPE == 5) begin
            $readmemh("../datatest/input.txt", mem);
        end 
        else begin
            for(i=0; i<511; i=i+1) begin
                mem[i] <= 32'b0;
            end
        end
    end

    always @(posedge clk) begin
        if(wEn) begin
            if(word_addr == 2'b00)      mem[row_addr][31:24] <= dataIn;
            else if(word_addr == 2'b01) mem[row_addr][23:16] <= dataIn;
            else if(word_addr == 2'b10) mem[row_addr][15:8]  <= dataIn;
            else if(word_addr == 2'b11) mem[row_addr][7:0]   <= dataIn;
        end
    end

    wire[7:0] word = (word_addr == 2'b00) ? row[31:24] :
                     (word_addr == 2'b01) ? row[23:16] :
                     (word_addr == 2'b10) ? row[15:8]  : row[7:0];

    assign dataOut = (rEn) ? word : 8'bz;

endmodule
