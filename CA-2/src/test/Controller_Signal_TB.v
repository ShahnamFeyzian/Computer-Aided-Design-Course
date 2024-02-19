`timescale 1ns/1ns

module Controller_Signal_TB();

    reg[3:0] ps=0;

    wire[0:0] b_regs_en, a_regs_en, a_muxs, pu_mult_regs_en, pu_add_regs_en, done;
    wire[1:0] res_mux;

    Controller controller(/*clk, rst, z0, z1, z2, z3, end_signal,*/ .ps(ps),
                  .b_regs_en(b_regs_en), .a_regs_en(a_regs_en), .a_muxs(a_muxs), .pu_mult_regs_en(pu_mult_regs_en), .pu_add_regs_en(pu_add_regs_en), .res_mux(res_mux), .done(done));

    always #5 ps = ps+1;

    initial #100 $stop;

endmodule
