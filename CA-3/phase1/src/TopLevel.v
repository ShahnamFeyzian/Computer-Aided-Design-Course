module TopLevel(clk, rst, done);

    parameter N = 4;

    input wire[0:0] clk, rst;
    output wire[0:0] done;

    wire[N-1:0] pe_rst;
    wire[0:0] pe_start, x_en, y_en, z_en, data_mem_addr_sel, pe_done, store_to_mem, buf_load, res_mem_wr_en;

    DataPath #(N) datapath(
        .clk(clk),                    .rst(rst),                    .xEnIn(x_en),                 
        .yEnIn(y_en),                 .zEnIn(z_en),                 .dataMemAddrSelIn(data_mem_addr_sel), 
        .resMemWrEnIn(res_mem_wr_en), .peStart(pe_start),           .peRstIn(pe_rst), 
        .peDoneOut(pe_done),          .storeToMemOut(store_to_mem), .bufLoadOut(buf_load)
    );
    
    Controller #(N) controller(
        .clk(clk), 
        .rst(rst),                             .peRstOut(pe_rst),             .peStartOut(pe_start), 
        .xEnOut(x_en),                         .yEnOut(y_en),                 .zEnOut(z_en), 
        .dataMemAddrSelOut(data_mem_addr_sel), .resMemWrEnOut(res_mem_wr_en), .done(done), 
        .peDoneIn(pe_done),                    .storeToMemIn(store_to_mem),   .bufLoadIn(buf_load)
    );

endmodule
