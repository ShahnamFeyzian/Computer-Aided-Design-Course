module DataPath(clk, rst, baseAddrSel, offsetAct, offsetMode, offsetRst,
                memREn, memWEn, fblRst, fblAct, filBufRst, filBufLd, fillBufISel,
                mbRst, mbShift, mbWrite, mblRst, mblAct, mbcRst, mbcEn,
                wbRst, wbLd, raAct, macRst, macAct, rbRst, rbEn, macClear, rbClear,
                offsetDone, mbcZero, raDone, rbFull);

    input wire[0:0] clk, rst, offsetAct, offsetRst,
                    memREn, memWEn, fblRst, fblAct, filBufRst, filBufLd, fillBufISel,
                    mbRst, mbShift, mbWrite, mblRst, mblAct, mbcRst, mbcEn,
                    wbRst, wbLd, raAct, macRst, macAct, rbRst, rbEn, macClear, rbClear;
    input wire[1:0] offsetMode, baseAddrSel;

    output wire[0:0] offsetDone, mbcZero, raDone, rbFull;

    reg[31:0] x_reg, y_reg, z_reg;
    initial begin
        x_reg = 32'd5;
        y_reg = 32'd71;
        z_reg = 32'd83;
    end

    wire[31:0] base_address = (baseAddrSel == 2'b00) ? x_reg :
                              (baseAddrSel == 2'b01) ? y_reg :
                              (baseAddrSel == 2'b10) ? z_reg : 32'bz;

    wire[31:0] offset;
    OffsetGenerator offsetGenerator(.clk(clk), .rst(offsetRst), .active(offsetAct), .mode(offsetMode), .val_out(offset), .done(offsetDone));

    wire[31:0] mem_address = offset + base_address;
    wire[31:0] mem_out;
    wire[7:0] res_buffer_out [0:3];
    Memory memory(.clk(clk), .rEn(memREn), .wEn(memWEn), .dataIn(res_buffer_out), .addrIn(mem_address), .dataOut(mem_out));

    wire[1:0] fbl_out;
    FB_LoadAddress fbLoadAddress(.clk(clk), .rst(fblRst), .active(fblAct), .valOut(fbl_out));

    wire[1:0] read_address_i, read_address_j;
    ReadAddress readAddress(.clk(clk), .rst(rst), .active(raAct), .iOut(read_address_i), .jOut(read_address_j), .done(raDone));

    wire[1:0] fil_buf_i = (fillBufISel) ? fbl_out : read_address_i;
    wire[7:0] fil_buf_out;
    FilterBuffer filterBuffer(.clk(clk), .rst(filBufRst), .ldEn(filBufLd), .iIndex(fil_buf_i), .jIndex(read_address_j), .dataIn(mem_out), .dataOut(fil_buf_out));

    wire[1:0] mbl_out;
    MB_LoadAddress mbLoadAddress(.clk(clk), .rst(mblRst), .active(mblAct), .addrOut(mbl_out));
    
    wire[3:0] mbc_out;
    MB_Counter mbCounter(.clk(clk), .rst(mbcRst), .en(mbcEn), .valOut(mbc_out), .zero(mbcZero));

    wire[7:0] middle_buffer_out [0:15];
    MiddleBuffer middleBuffer(.clk(clk), .rst(mbRst), .shiftEn(mbShift), .writeEn(mbWrite), .writeIndex(mbl_out), .readIndex(mbc_out), .dataIn(mem_out), .dataOut(middle_buffer_out));

    wire[7:0] window_out;
    WindowBuffer windowBuffer(.clk(clk), .rst(wbRst), .ld(wbLd), .iIndex(read_address_i), .jIndex(read_address_j), .dataIn(middle_buffer_out), .dataOut(window_out));

    wire[7:0] mac_out;
    MAC mac(.clk(clk), .rst(macRst), .active(macAct), .clear(macClear), .val1In(fil_buf_out), .val2In(window_out), .valOut(mac_out));

    ResBuffer resBuffer(.clk(clk), .rst(rbRst), .en(rbEn), .clear(rbClear), .valIn(mac_out), .full(rbFull), .valOut(res_buffer_out));

endmodule
