module Datapath(clk, rst, b0_in, b1_in, b2_in, b3_in,
                b_regs_en, a_regs_en, a_muxs, pu_mult_regs_en, pu_add_regs_en, res_mux, done,
                z0, z1, z2, z3, end_signal, 
                result);

    input wire[0:0] clk, rst, b_regs_en, a_regs_en, a_muxs, pu_mult_regs_en, pu_add_regs_en, done;
    input wire[1:0] res_mux;
    input wire[4:0] b0_in, b1_in, b2_in, b3_in;

    output wire[0:0] z0, z1, z2, z3, end_signal;
    output wire[4:0] result;

    // b registers
    wire[4:0] b0_out, b1_out, b2_out, b3_out;
    E_REG #(5) b0(.clk(clk), .rst(rst), .en(b_regs_en), .in(b0_in), .out(b0_out));
    E_REG #(5) b1(.clk(clk), .rst(rst), .en(b_regs_en), .in(b1_in), .out(b1_out));
    E_REG #(5) b2(.clk(clk), .rst(rst), .en(b_regs_en), .in(b2_in), .out(b2_out));
    E_REG #(5) b3(.clk(clk), .rst(rst), .en(b_regs_en), .in(b3_in), .out(b3_out));

    // result multiplexer
    wire[4:0] final_res;
    E_MUX #(5) result_mux(.a00(b0_out), .a01(b1_out), .a10(b2_out), .a11(b3_out), .sel(res_mux), .out(final_res));

    // a multiplexers
    wire[4:0] pu0_out, pu1_out, pu2_out, pu3_out;
    wire[4:0] a0_in, a1_in, a2_in, a3_in;
    E_MUX #(5) a0_mux(.a00(pu0_out), .a01(b0_out), .a10(1'bz), .a11(1'bz), .sel({1'b0, a_muxs}), .out(a0_in));
    E_MUX #(5) a1_mux(.a00(pu1_out), .a01(b1_out), .a10(1'bz), .a11(1'bz), .sel({1'b0, a_muxs}), .out(a1_in));
    E_MUX #(5) a2_mux(.a00(pu2_out), .a01(b2_out), .a10(1'bz), .a11(1'bz), .sel({1'b0, a_muxs}), .out(a2_in));
    E_MUX #(5) a3_mux(.a00(pu3_out), .a01(b3_out), .a10(1'bz), .a11(1'bz), .sel({1'b0, a_muxs}), .out(a3_in));

    // a registers
    wire[4:0] a0_out, a1_out, a2_out, a3_out;
    E_REG #(5) a0(.clk(clk), .rst(rst), .en(a_regs_en), .in(a0_in), .out(a0_out));
    E_REG #(5) a1(.clk(clk), .rst(rst), .en(a_regs_en), .in(a1_in), .out(a1_out));
    E_REG #(5) a2(.clk(clk), .rst(rst), .en(a_regs_en), .in(a2_in), .out(a2_out));
    E_REG #(5) a3(.clk(clk), .rst(rst), .en(a_regs_en), .in(a3_in), .out(a3_out));

    // weights' buffer in order  (0->w00) (1->w01) (2->w02) (3->w03) (4->w11) (5->w12) (6->w13) (7->w22) (8->w23) (9->w33)
    wire[4:0] weights[0:9];
    Weight_Buffer buffer(.clk(clk), .weights(weights));

    // PUs
    wire[0:0] pu0_z, pu1_z, pu2_z, pu3_z;
    PU pu0(
        .clk(clk),                     
        .x0(a0_out),                   .x1(a1_out), 
        .x2(a2_out),                   .x3(a3_out), 
        .w0(weights[0]),               .w1(weights[1]), 
        .w2(weights[2]),               .w3(weights[3]), 
        .mult_reg_en(pu_mult_regs_en), .add_reg_en(pu_add_regs_en), 
        .Zero_signal(pu0_z),           .new_value(pu0_out)
    );
    assign z0 = pu0_z;

    PU pu1(
        .clk(clk),                     
        .x0(a0_out),                   .x1(a1_out), 
        .x2(a2_out),                   .x3(a3_out), 
        .w0(weights[1]),               .w1(weights[4]), 
        .w2(weights[5]),               .w3(weights[6]), 
        .mult_reg_en(pu_mult_regs_en), .add_reg_en(pu_add_regs_en), 
        .Zero_signal(pu1_z),           .new_value(pu1_out)
    );
    assign z1 = pu1_z;

    PU pu2(
        .clk(clk),                     
        .x0(a0_out),                   .x1(a1_out), 
        .x2(a2_out),                   .x3(a3_out), 
        .w0(weights[2]),               .w1(weights[5]), 
        .w2(weights[7]),               .w3(weights[8]), 
        .mult_reg_en(pu_mult_regs_en), .add_reg_en(pu_add_regs_en), 
        .Zero_signal(pu2_z),           .new_value(pu2_out)
    );
    assign z2 = pu2_z;

    PU pu3(
        .clk(clk),                     
        .x0(a0_out),                   .x1(a1_out), 
        .x2(a2_out),                   .x3(a3_out), 
        .w0(weights[3]),               .w1(weights[6]), 
        .w2(weights[8]),               .w3(weights[9]), 
        .mult_reg_en(pu_mult_regs_en), .add_reg_en(pu_add_regs_en), 
        .Zero_signal(pu3_z),           .new_value(pu3_out)
    );
    assign z3 = pu3_z;

    // End Signal Generator
    ESG esg(.PU0_zero(pu0_z), .PU1_zero(pu1_z), .PU2_zero(pu2_z), .PU3_zero(pu3_z), .end_signal(end_signal));

    // showing result
    E_MUX #(5) show_mux(.a00(5'bz), .a01(final_res), .a10(5'bz), .a11(5'bz), .sel({1'b0, done}), .out(result));

endmodule
