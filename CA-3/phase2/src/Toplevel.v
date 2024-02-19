module Toplevel(clk, rst, done);

    parameter X = 0, Y = 0,
              Z = 0, M = 0;

    input wire[0:0]  clk, rst;
    output wire[0:0] done;

    wire [0:0] 
        ld_buf_L1, pe_start_L1,
        mem_wr_en_L2, init_ld_L1,
        ld_buf_done_L1, ctrl_done_L1,
        pe_done_L1, start_ld_pic_L2,
        init_ld_L2, ld_buf_L2,
        pe_start_L2, mem_wr_en_L3,
        ld_buf_done_L2, ctrl_done_L2,
        pe_done_L2;

    Datapath #(.X(X), .Y(Y), .Z(Z), .M(M))
    datapath(
        .clk(clk), .rst(rst), 
    
        .ldBufL1(ld_buf_L1), .peStartL1(pe_start_L1), .memWrEnL2(mem_wr_en_L2), .initLdL1(init_ld_L1), 
        .startLdPicL2(start_ld_pic_L2), .initLdL2(init_ld_L2), .ldBufL2(ld_buf_L2),
        .peStartL2(pe_start_L2), .memWrEnL3(mem_wr_en_L3),
        
        .ldBufDoneL1(ld_buf_done_L1), .ctrlDoneL1(ctrl_done_L1), .peDoneL1(pe_done_L1), 
        .ldBufDoneL2(ld_buf_done_L2), .ctrlDoneL2(ctrl_done_L2), .peDoneL2(pe_done_L2) 
    );

    Controlelr controller(
        .clk(clk), .rst(rst), 
    
        .ldBufL1(ld_buf_L1), .peStartL1(pe_start_L1), .memWrEnL2(mem_wr_en_L2), .initLdL1(init_ld_L1), 
        .startLdPicL2(start_ld_pic_L2), .initLdL2(init_ld_L2), .ldBufL2(ld_buf_L2),
        .peStartL2(pe_start_L2), .memWrEnL3(mem_wr_en_L3), .done(done),
        
        .ldBufDoneL1(ld_buf_done_L1), .ctrlDoneL1(ctrl_done_L1), .peDoneL1(pe_done_L1), 
        .ldBufDoneL2(ld_buf_done_L2), .ctrlDoneL2(ctrl_done_L2), .peDoneL2(pe_done_L2) 
    );

endmodule
