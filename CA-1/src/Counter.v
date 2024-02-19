module Counter(clk, rst, set, cnt_en, set_val, val_out);
    parameter B = 2;

    input wire[0:0] clk, rst, set, cnt_en;
    input wire[B-1 : 0] set_val;

    output reg[B-1 : 0] val_out;

    always@(posedge clk, posedge rst)
    begin

        if(rst)         val_out <= 2'b0;
        else if(set)    val_out <= set_val;
        else if(cnt_en) val_out <= val_out + 1;

    end
endmodule
