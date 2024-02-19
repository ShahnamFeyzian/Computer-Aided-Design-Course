`define IDLE          4'b0000
`define LOAD_B_REGS   4'b0001
`define LOAD_A_REGS   4'b0010
`define PU_MULT       4'b0011
`define PU_ADD        4'b0100
`define UPDATE_A_REGS 4'b0101
`define FIND_RES      4'b0110
`define RES0          4'b0111
`define RES1          4'b1000
`define RES2          4'b1001
`define RES3          4'b1010

`define STATE_BITS 4

module Controller(clk, rst, z0, z1, z2, z3, end_signal,
                  b_regs_en, a_regs_en, a_muxs, pu_mult_regs_en, pu_add_regs_en, res_mux, done);

    input wire[0:0] clk, rst, z0, z1, z2, z3, end_signal;

    output wire[0:0] b_regs_en, a_regs_en, a_muxs, pu_mult_regs_en, pu_add_regs_en, done;
    output wire[1:0] res_mux;

    wire[`STATE_BITS-1:0] ps, ns;
    E_REG #(`STATE_BITS) state (.clk(clk), .rst(rst), .en(1'b1), .in(ns), .out(ps));


    /*--------------------------------------------------------- issue output signals ---------------------------------------------------------*/

    // issue b_regs_en signal
    Comparator #(`STATE_BITS) cmp_load_b(.a(`LOAD_B_REGS), .b(ps), .out(b_regs_en));

    // issue a_regs_en signal
    wire[0:0] is_load_a, is_update_a;
    Comparator #(`STATE_BITS) cmp_load_a(.a(`LOAD_A_REGS), .b(ps), .out(is_load_a));
    Comparator #(`STATE_BITS) cmp_update_a(.a(`UPDATE_A_REGS), .b(ps), .out(is_update_a));
    C_OR load_or_update_a(.a(is_load_a), .b(is_update_a), .out(a_regs_en));

    // issue a_muxs signal
    assign a_muxs = is_load_a;

    // issue pu_mult_regs_en signal
    Comparator #(`STATE_BITS) cmp_pu_mult(.a(`PU_MULT), .b(ps), .out(pu_mult_regs_en));

    // issue pu_add_regs_en signal
    Comparator #(`STATE_BITS) cmp_pu_add(.a(`PU_ADD), .b(ps), .out(pu_add_regs_en));

    // issue res_mux signal
    wire[0:0] is_res0, is_res1, is_res2, is_res3;
    Comparator #(`STATE_BITS) cmp_res0(.a(`RES0), .b(ps), .out(is_res0));
    Comparator #(`STATE_BITS) cmp_res1(.a(`RES1), .b(ps), .out(is_res1));
    Comparator #(`STATE_BITS) cmp_res2(.a(`RES2), .b(ps), .out(is_res2));
    Comparator #(`STATE_BITS) cmp_res3(.a(`RES3), .b(ps), .out(is_res3));
    C_OR res1_or_res3(.a(is_res1), .b(is_res3), .out(res_mux[0]));
    C_OR res2_or_res3(.a(is_res2), .b(is_res3), .out(res_mux[1]));

    // issue done signal
    wire[0:0] is_res;
    E_OR #(4) done_generator(.in({is_res0, is_res1, is_res2, is_res3}), .out(is_res));
    assign done = is_res;


    /*--------------------------------------------------------- generate next state ---------------------------------------------------------*/
    
    // generate mux1 select signal
    wire[1:0] sel1;
    wire[0:0] end_bar;
    C_INV inv(.in(end_signal), .out(end_bar));
    C_AND c_and(.a(end_bar), .b(is_update_a), .out(sel1[0]));
    assign sel1[1] = is_res;

    // generate mux1
    wire[`STATE_BITS-1:0] ps_plus, mux1_out;
    Adder #(`STATE_BITS) adder(.a(ps), .b({`STATE_BITS{1'b0}}), .cin(1'b1), .s(ps_plus));
    E_MUX #(`STATE_BITS) mux1(.a00(ps_plus), .a01(`PU_MULT), .a10(ps), .a11({`STATE_BITS{1'bz}}), .sel(sel1), .out(mux1_out));

    // generate mux2 select signal
    wire[1:0] sel2;
    wire[3:0] z_bars;
    E_INV #(4) z_inv(.in({z3, z2, z1, z0}), .out(z_bars));
    C_OR z1_or_z3(.a(z_bars[1]), .b(z_bars[3]), .out(sel2[0]));
    C_OR z2_or_z3(.a(z_bars[2]), .b(z_bars[3]), .out(sel2[1]));

    // generate mux2
    wire[`STATE_BITS-1:0] mux2_out;
    E_MUX #(`STATE_BITS) mux2(.a00(`RES0), .a01(`RES1), .a10(`RES2), .a11(`RES3), .sel(sel2), .out(mux2_out));

    // generate mux3 select signal
    wire[1:0] sel3;
    Comparator #(`STATE_BITS) cmp_find_res(.a(`FIND_RES), .b(ps), .out(sel3[0]));
    assign sel3[1] = 1'b0;

    // generate mux3
    E_MUX #(`STATE_BITS) mux3(.a00(mux1_out), .a01(mux2_out), .a10(1'bz), .a11(1'bz), .sel(sel3), .out(ns));

endmodule
