module FP_Adder(val1, val2, val_out);

    input wire[31:0] val1, val2;

    output reg[31:0] val_out;


    reg[0:0] is_1_bigger, b_val_sign, s_val_sign, carry;
    reg[7:0] b_val_exp, s_val_exp, mid_exp;
    reg[23:0] b_val_frac, s_val_frac, mid_frac;

    always@(val1, val2)
    begin

        if(val1[30:23] == val2[30:23]) is_1_bigger = (val1[22:0] >= val2[22:0])? 1'b1 : 1'b0;
        else is_1_bigger = (val1[30:23] >= val2[30:23])? 1'b1 : 1'b0;
    
        // bigger number partition
        b_val_frac = (is_1_bigger) ? {1'b1, val1[22:0]} : {1'b1, val2[22:0]};
        b_val_exp  = (is_1_bigger) ? val1[30:23] : val2[30:23];
        b_val_sign = (is_1_bigger) ? val1[31] : val2[31];

        // smaller number partition
        s_val_frac = (~is_1_bigger) ? {1'b1, val1[22:0]} : {1'b1, val2[22:0]};
        s_val_exp  = (~is_1_bigger) ? val1[30:23] : val2[30:23];
        s_val_sign = (~is_1_bigger) ? val1[31] : val2[31];

        s_val_frac = s_val_frac >> (b_val_exp - s_val_exp);

        {carry, mid_frac} = (b_val_sign == s_val_sign) ? b_val_frac + s_val_frac : b_val_frac - s_val_frac;
        mid_exp = b_val_exp;

        if(carry) begin
          mid_frac = mid_frac >> 1;
          mid_exp = mid_exp + 1'b1;
        end
        else if(mid_frac != 24'b0) begin
            while(!mid_frac[23]) begin
                mid_frac = mid_frac << 1;
                mid_exp = mid_exp - 1'b1;
            end
        end

        val_out = (mid_frac == 24'b0) ? 32'b0 : {b_val_sign, mid_exp, mid_frac[22:0]};
    end
    
endmodule
