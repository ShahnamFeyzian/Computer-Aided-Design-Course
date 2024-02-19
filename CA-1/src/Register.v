module Register(clk, rst, ld_en, val_in, val_out);
    parameter B = 32;

    input wire[0:0] clk, rst, ld_en;
    input wire[B-1 : 0] val_in;

    output reg[B-1 : 0] val_out;

    always@(posedge clk, posedge rst)
    begin

        if(rst)        val_out <= 32'b0;
        else if(ld_en) val_out <= val_in;

    end
endmodule
