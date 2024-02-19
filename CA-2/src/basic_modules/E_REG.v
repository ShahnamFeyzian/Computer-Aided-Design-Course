module E_REG(clk, rst, en, in, out);

    parameter N = 32;

    input wire[0:0] clk, rst, en;
    input wire[N-1:0] in;
    output wire[N-1:0] out;

    genvar i;
    generate
        for(i=0; i<N; i=i+1) begin
            S_REG s_reg(.clk(clk), .rst(rst), .en(en), .in(in[i]), .out(out[i]));
        end
    endgenerate

endmodule
