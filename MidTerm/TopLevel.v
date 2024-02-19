module TopLevel(clk, rst, done);

    input wire[0:0] clk, rst;
    output wire[0:0] done;

    wire[0:0] ofsset_done, offset_active, offset_rst,
              mem_r_en, mem_w_en, fbl_rst, fbl_active, fil_buf_rst, fil_buf_ld, fill_buf_i_sel,
              mb_rst, mb_shift, mb_write, mbl_rst, mbl_active, mbc_rst, mbc_en, mbc_zero, ra_done,
              wb_rst, wb_ld, ra_active, mac_rst, mac_active, rb_rst, rb_en, rb_full, mac_clear, rb_clear;
    wire[1:0] offset_mode, base_address;

    DataPath DataPath(.clk(clk), .rst(rst), .baseAddrSel(base_address), .offsetAct(offset_active), .offsetMode(offset_mode), .offsetRst(offset_rst),
                .memREn(mem_r_en), .memWEn(mem_w_en), .fblRst(fbl_rst), .fblAct(fbl_active), .filBufRst(fil_buf_rst), .filBufLd(fil_buf_ld), .fillBufISel(fill_buf_i_sel),
                .mbRst(mb_rst), .mbShift(mb_shift), .mbWrite(mb_write), .mblRst(mbl_rst), .mblAct(mbl_active), .mbcRst(mbc_rst), .mbcEn(mbc_en),
                .wbRst(wb_rst), .wbLd(wb_ld), .raAct(ra_active), .macRst(mac_rst), .macAct(mac_active), .rbRst(rb_rst), .rbEn(rb_en), .macClear(mac_clear), .rbClear(rb_clear),
                .offsetDone(ofsset_done), .mbcZero(mbc_zero), .raDone(ra_done), .rbFull(rb_full));

    Controller controller(.clk(clk), .rst(rst), .offsetDone(ofsset_done), .mbcZero(mbc_zero), .raDone(ra_done), .rbFull(rb_full),
                  .offsetActive(offset_active), .offsetMode(offset_mode), .offsetRst(offset_rst), .baseAddrSel(base_address),
                  .memREn(mem_r_en), .memWEn(mem_w_en), .fblRst(fbl_rst), .fblAct(fbl_active), .filBufRst(fil_buf_rst), .filBufLd(fil_buf_ld), .fillBufISel(fill_buf_i_sel),
                  .mbRst(mb_rst), .mbShift(mb_shift), .mbWrite(mb_write), .mblRst(mbl_rst), .mblAct(mbl_active), .mbcRst(mbc_rst), .mbcEn(mbc_en), .macClear(mac_clear), .rbClear(rb_clear),
                  .wbRst(wb_rst), .wbLd(wb_ld), .raAct(ra_active), .macRst(mac_rst), .macAct(mac_active), .rbRst(rb_rst), .rbEn(rb_en), .done(done));

endmodule
