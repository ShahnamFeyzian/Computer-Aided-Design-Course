module TopLevel(clk, rst, done, result);

    input wire[0:0] clk, rst;

    output wire[0:0] done;
    output wire[31:0] result;


    wire[0:0] addr_rst, addr_cnt_en, addr_set, mem_r_en, a_muxs, a0_reg_en, a1_reg_en, a2_reg_en, a3_reg_en, pu_mult_regs_en, 
              pu_add_regs_en, internal_done, pu0_z, pu1_z, pu2_z, pu3_z, end_signal;
    wire[1:0] addr_mux;


    DataPath dataPath(
        .clk(clk),                       .addr_mux(addr_mux), 
        .addr_rst(addr_rst),             .addr_cnt_en(addr_cnt_en), 
        .addr_set(addr_set),             .mem_r_en(mem_r_en), 
        .a_muxs(a_muxs),                 .a0_reg_en(a0_reg_en), 
        .a1_reg_en(a1_reg_en),           .a2_reg_en(a2_reg_en), 
        .a3_reg_en(a3_reg_en),           .pu_mult_regs_en(pu_mult_regs_en), 
        .pu_add_regs_en(pu_add_regs_en), .done(internal_done),
        .pu0_z(pu0_z),                   .pu1_z(pu1_z), 
        .pu2_z(pu2_z),                   .pu3_z(pu3_z), 
        .end_signal(end_signal),         .result(result)
    );


    ControlUnit controller(
        .clk(clk),                       .rst(rst), 
        .pu0_z(pu0_z),                   .pu1_z(pu1_z), 
        .pu2_z(pu2_z),                   .pu3_z(pu3_z), 
        .end_signal(end_signal),         .addr_mux(addr_mux), 
        .addr_rst(addr_rst),             .addr_cnt_en(addr_cnt_en), 
        .addr_set(addr_set),             .mem_r_en(mem_r_en), 
        .a_muxs(a_muxs),                 .a0_reg_en(a0_reg_en), 
        .a1_reg_en(a1_reg_en),           .a2_reg_en(a2_reg_en), 
        .a3_reg_en(a3_reg_en),           .pu_mult_regs_en(pu_mult_regs_en), 
        .pu_add_regs_en(pu_add_regs_en), .done(internal_done)
    );

    assign done = internal_done;

endmodule
