module DataPath(
    clk, addr_mux, addr_rst, addr_cnt_en, addr_set, 
    mem_r_en, a_muxs, a0_reg_en, a1_reg_en, a2_reg_en, 
    a3_reg_en, pu_mult_regs_en, pu_add_regs_en, done,
    pu0_z, pu1_z, pu2_z, pu3_z, end_signal, result
);

    input wire[0:0] clk, addr_rst, addr_cnt_en, addr_set, mem_r_en, a_muxs,
                    a0_reg_en, a1_reg_en, a2_reg_en, a3_reg_en,
                    pu_mult_regs_en, pu_add_regs_en, done;  
    input wire[1:0] addr_mux;

    output wire[0:0] pu0_z, pu1_z, pu2_z, pu3_z, end_signal;
    output wire[31:0] result;


    // multiplexer that choose counter set value
    wire[1:0] counter_set = (addr_mux == 2'b00) ? 2'b00 :
                            (addr_mux == 2'b01) ? 2'b01 :
                            (addr_mux == 2'b10) ? 2'b10 :
                            (addr_mux == 2'b11) ? 2'b11 : 2'bz;
    
    wire[1:0] mem_addr;
    Counter addrCounter(
        // counter that generates memory address
        .clk(clk),             .rst(addr_rst), 
        .set(addr_set),        .cnt_en(addr_cnt_en), 
        .set_val(counter_set), .val_out(mem_addr)
    );

    wire[31:0] mem_out;
    RO_Memory memory(
        // memory that keeps Xs' values 
        .read_en(mem_r_en), .addr(mem_addr), .val_out(mem_out)
    );

    // connection network wires
    wire[31:0] a0_old, a0_new,
               a1_old, a1_new,
               a2_old, a2_new,
               a3_old, a3_new;
               

    // a registers
    wire[31:0] a0_in = (~a_muxs) ? a0_new : mem_out;
    Register a0Reg(.clk(clk), .rst(1'b0), .ld_en(a0_reg_en), .val_in(a0_in), .val_out(a0_old));

    wire[31:0] a1_in = (~a_muxs) ? a1_new : mem_out;
    Register a1Reg(.clk(clk), .rst(1'b0), .ld_en(a1_reg_en), .val_in(a1_in), .val_out(a1_old));

    wire[31:0] a2_in = (~a_muxs) ? a2_new : mem_out;
    Register a2Reg(.clk(clk), .rst(1'b0), .ld_en(a2_reg_en), .val_in(a2_in), .val_out(a2_old));

    wire[31:0] a3_in = (~a_muxs) ? a3_new : mem_out;
    Register a3Reg(.clk(clk), .rst(1'b0), .ld_en(a3_reg_en), .val_in(a3_in), .val_out(a3_old));

    // weights' buffer in order  (0->w00) (1->w01) (2->w02) (3->w03) (4->w11) (5->w12) (6->w13) (7->w22) (8->w23) (9->w33)
    wire[31:0] weights[0:9];
    WeightBuffer buffer(.weights(weights));

    wire[0:0] z0;
    PU pu0(
        .clk(clk),                     
        .x0(a0_old),                   .x1(a1_old), 
        .x2(a2_old),                   .x3(a3_old), 
        .w0(weights[0]),               .w1(weights[1]), 
        .w2(weights[2]),               .w3(weights[3]), 
        .mult_reg_en(pu_mult_regs_en), .add_reg_en(pu_add_regs_en), 
        .Zero_signal(z0),              .new_value(a0_new)
    );
    assign pu0_z = z0;

    wire[0:0] z1;
    PU pu1(
        .clk(clk),                     
        .x0(a0_old),                   .x1(a1_old), 
        .x2(a2_old),                   .x3(a3_old), 
        .w0(weights[1]),               .w1(weights[4]), 
        .w2(weights[5]),               .w3(weights[6]), 
        .mult_reg_en(pu_mult_regs_en), .add_reg_en(pu_add_regs_en), 
        .Zero_signal(z1),              .new_value(a1_new)
    );
    assign pu1_z = z1;

    wire[0:0] z2;
    PU pu2(
        .clk(clk),                     
        .x0(a0_old),                   .x1(a1_old), 
        .x2(a2_old),                   .x3(a3_old), 
        .w0(weights[2]),               .w1(weights[5]), 
        .w2(weights[7]),               .w3(weights[8]), 
        .mult_reg_en(pu_mult_regs_en), .add_reg_en(pu_add_regs_en), 
        .Zero_signal(z2),              .new_value(a2_new)
    );
    assign pu2_z = z2;

    wire[0:0] z3;
    PU pu3(
        .clk(clk),                     
        .x0(a0_old),                   .x1(a1_old), 
        .x2(a2_old),                   .x3(a3_old), 
        .w0(weights[3]),               .w1(weights[6]), 
        .w2(weights[8]),               .w3(weights[9]), 
        .mult_reg_en(pu_mult_regs_en), .add_reg_en(pu_add_regs_en), 
        .Zero_signal(z3),              .new_value(a3_new)
    );
    assign pu3_z = z3;


    ESG esg(.PU0_zero(z0), .PU1_zero(z1), .PU2_zero(z2), .PU3_zero(z3), .end_signal(end_signal));

    assign result = (done) ? mem_out : 32'bz;

endmodule
