module PE(clk, rst, memoryIn, startIn, done, resOut, storeToMemOut, bufLoadOut);

    input wire[0:0] clk, rst, startIn;
    input wire[31:0] memoryIn;

    output wire[0:0] done, storeToMemOut, bufLoadOut;
    output wire[31:0] resOut;

    wire[0:0] 
        fbl_rst,        fbl_active, fil_buf_rst, fil_buf_ld, 
        fill_buf_i_sel, rb_rst,     mb_rst,      mb_shift, 
        mb_write,       mbl_rst,    mbl_active,  mbc_rst, 
        mbc_en,         mbc_zero,   ra_done,     wb_rst, wb_ld, 
        ra_active,      mac_rst,    mac_active,  rb_en, 
        rb_full,        mac_clear,  rb_clear;

    PE_DataPath datapath(
        .clk(clk),               .rst(rst),             .fblRst(fbl_rst),            .fblAct(fbl_active), 
        .filBufRst(fil_buf_rst), .filBufLd(fil_buf_ld), .fillBufISel(fill_buf_i_sel),.mbRst(mb_rst), 
        .mbShift(mb_shift),      .mbWrite(mb_write),    .mblRst(mbl_rst),            .mblAct(mbl_active), 
        .mbcRst(mbc_rst),        .mbcEn(mbc_en),        .memIn(memoryIn),            .wbRst(wb_rst), 
        .wbLd(wb_ld),            .raAct(ra_active),     .macRst(mac_rst),            .macAct(mac_active), 
        .rbRst(rb_rst),          .rbEn(rb_en),          .macClear(mac_clear),        .rbClear(rb_clear), 
        .mbcZero(mbc_zero),      .raDone(ra_done),      .rbFull(rb_full),            .resBufOut(resOut)
    );

    PE_Controller controller(
        .clk(clk),                    .rst(rst), 
        .start(startIn),              .mbcZero(mbc_zero),  .raDone(ra_done),              .rbFull(rb_full),
        .fblRst(fbl_rst),             .fblAct(fbl_active), .filBufRst(fil_buf_rst),       .filBufLd(fil_buf_ld), 
        .fillBufISel(fill_buf_i_sel), .mbRst(mb_rst),      .mbShift(mb_shift),            .mbWrite(mb_write), 
        .mblRst(mbl_rst),             .mblAct(mbl_active), .mbcRst(mbc_rst),              .mbcEn(mbc_en), 
        .macClear(mac_clear),         .rbClear(rb_clear),  .wbRst(wb_rst),                .wbLd(wb_ld), 
        .raAct(ra_active),            .macRst(mac_rst),    .macAct(mac_active),           .rbRst(rb_rst), 
        .rbEn(rb_en),                 .done(done),         .storeToMemOut(storeToMemOut), .bufLoadOut(bufLoadOut)
    );

endmodule
