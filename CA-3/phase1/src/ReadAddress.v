module ReadAddress(clk, rst, active, iOut, jOut, done);

    input wire[0:0] clk, rst, active;

    output wire[0:0] done;
    output wire[1:0] iOut, jOut;

    reg[3:0] counter;

    always @(posedge clk, posedge rst) begin
        if(rst) counter <= 4'b0;
        else if(active) counter <= counter + 1;
    end

    assign {iOut, jOut} = counter;
    assign done = (counter == 4'd15) ? 1'b1 : 1'b0;

endmodule
