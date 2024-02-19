module PE_DataPath(
    clk, rst, fblRst, fblAct, filBufRst, filBufLd, fillBufISel,
    mbRst, mbShift, mbWrite, mblRst, mblAct, mbcRst, mbcEn, memIn,
    wbRst, wbLd, raAct, macRst, macAct, rbRst, rbEn, macClear, rbClear,
    mbcZero, raDone, rbFull, resBufOut
);

    input wire[0:0] 
        clk, rst, fblRst, fblAct, filBufRst, filBufLd, 
        fillBufISel, mbRst, mbShift, mbWrite, mblRst, mblAct, mbcRst, mbcEn,
        wbRst, wbLd, raAct, macRst, macAct, rbRst, rbEn, macClear, rbClear;
    
    input wire[31:0] memIn;

    output  wire[0:0] mbcZero, raDone, rbFull;
    output wire[31:0] resBufOut;

    wire[1:0] fbl_out;
    FB_LoadAddress fbLoadAddress(
        .clk(clk),       .rst(fblRst), 
        .active(fblAct), .valOut(fbl_out)
    );

    wire[1:0] read_address_i, read_address_j;
    ReadAddress readAddress(
        .clk(clk),             .rst(rst), 
        .active(raAct),        .iOut(read_address_i), 
        .jOut(read_address_j), .done(raDone)
    );

    wire[1:0] fil_buf_i = (fillBufISel) ? fbl_out : read_address_i;
    wire[7:0] fil_buf_out;
    FilterBuffer filterBuffer(
        .clk(clk),               
        .rst(filBufRst),    .ldEn(filBufLd),         
        .iIndex(fil_buf_i), .jIndex(read_address_j), 
        .dataIn(memIn),     .dataOut(fil_buf_out)
    );

    wire[1:0] mbl_out;
    MB_LoadAddress mbLoadAddress(
        .clk(clk),       .rst(mblRst), 
        .active(mblAct), .addrOut(mbl_out)
    );
    
    wire[3:0] mbc_out;
    MB_Counter mbCounter(
        .clk(clk), 
        .rst(mbcRst),     .en(mbcEn), 
        .valOut(mbc_out), .zero(mbcZero)
    );

    wire[7:0] middle_buffer_out [0:15];
    MiddleBuffer middleBuffer(
        .clk(clk),            .rst(mbRst), 
        .shiftEn(mbShift),    .writeEn(mbWrite), 
        .writeIndex(mbl_out), .readIndex(mbc_out), 
        .dataIn(memIn),       .dataOut(middle_buffer_out)
    );

    wire[7:0] window_out;
    WindowBuffer windowBuffer(
        .clk(clk), 
        .rst(wbRst),                .ld(wbLd), 
        .iIndex(read_address_i),    .jIndex(read_address_j), 
        .dataIn(middle_buffer_out), .dataOut(window_out)
    );

    wire[7:0] mac_out;
    MAC mac(
        .clk(clk), 
        .rst(macRst),        .active(macAct), 
        .clear(macClear),    .val1In(fil_buf_out), 
        .val2In(window_out), .valOut(mac_out)
    );

    wire[7:0] res_buf_out [0:3];
    ResBuffer resBuffer(
        .clk(clk), 
        .rst(rbRst),     .en(rbEn), 
        .clear(rbClear), .valIn(mac_out), 
        .full(rbFull),   .valOut(res_buf_out)
    );

    assign resBufOut = {res_buf_out[0], res_buf_out[1], res_buf_out[2], res_buf_out[3]};

endmodule
