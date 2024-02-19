module Toplevel(clk, rst, b0_in, b1_in, b2_in, b3_in,
                done, result);

    input wire[0:0] clk, rst;
    input wire[4:0] b0_in, b1_in, b2_in, b3_in;
    
    output wire[0:0] done;
    output wire[4:0] result;

    wire[0:0] b_regs_en, a_regs_en, a_muxs, pu_mult_regs_en, pu_add_regs_en,
              z0, z1, z2, z3, end_signal, done1;
    wire[1:0] res_mux;

    Datapath datapath(
        .clk(clk), .rst(rst),            .b0_in(b0_in), .b1_in(b1_in), 
        .b2_in(b2_in), .b3_in(b3_in),    .b_regs_en(b_regs_en), .a_regs_en(a_regs_en), 
        .a_muxs(a_muxs),                 .pu_mult_regs_en(pu_mult_regs_en), 
        .pu_add_regs_en(pu_add_regs_en), .res_mux(res_mux),
        .z0(z0), .z1(z1),                .z2(z2), .z3(z3), 
        .end_signal(end_signal),         .result(result), .done(done1)
    );

    Controller controller(
        .clk(clk), .rst(rst),            .z0(z0), .z1(z1), 
        .z2(z2), .z3(z3),                .end_signal(end_signal),
        .b_regs_en(b_regs_en),           .a_regs_en(a_regs_en), 
        .a_muxs(a_muxs),                 .pu_mult_regs_en(pu_mult_regs_en), 
        .pu_add_regs_en(pu_add_regs_en), .res_mux(res_mux), 
        .done(done1)
    );

    assign done = done1;

endmodule
