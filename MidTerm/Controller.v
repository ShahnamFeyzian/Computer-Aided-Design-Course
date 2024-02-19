`define IDEL                4'd0
`define LOAD_FILTER         4'd1
`define INITIAL_BUFFER_LOAD 4'd2
`define INITIAL_SHIFT       4'd3
`define WINDOW_LOAD         4'd4 
`define CALC                4'd5
`define STORE_RES_BUF       4'd6
`define STORE_TO_MEM        4'd7
`define SHIFT_UPDATE        4'd8
`define BUFFER_LOAD_UPDATE  4'd9
`define LAST_STORING        4'd10
`define DONE                4'd11

module Controller(clk, rst, offsetDone, mbcZero, raDone, rbFull,
                  offsetActive, offsetMode, offsetRst, baseAddrSel,
                  memREn, memWEn, fblRst, fblAct, filBufRst, filBufLd, fillBufISel,
                  mbRst, mbShift, mbWrite, mblRst, mblAct, mbcRst, mbcEn, macClear, rbClear,
                  wbRst, wbLd, raAct, macRst, macAct, rbRst, rbEn, done);

    input wire[0:0] clk, rst, offsetDone, mbcZero, raDone, rbFull;

    output reg[0:0] offsetActive, offsetRst, memREn, memWEn, fblRst, fblAct, filBufRst, filBufLd, fillBufISel,
                    mbRst, mbShift, mbWrite, mblRst, mblAct, mbcRst, mbcEn, macClear, rbClear,
                    wbRst, wbLd, raAct, macRst, macAct, rbRst, rbEn, done;
    output reg[1:0] offsetMode, baseAddrSel;

    reg[3:0] ps, ns;
    reg[1:0] initial_cnt;
    reg[3:0] update_cnt;

    always @(posedge clk, posedge rst) begin
        if(rst) begin 
            ps <= `IDEL; 
            initial_cnt <= 2'b0; 
            update_cnt  <= 4'b0;
            end
        else begin
            ps <= ns;
            if(ps == `INITIAL_BUFFER_LOAD && offsetDone == 1'b1) initial_cnt <= initial_cnt + 1;
            else if(ps == `SHIFT_UPDATE) update_cnt <= update_cnt + 1;
        end
    end

    always @(*) begin
        case(ps)
            `IDEL : ns = (rst) ? `IDEL : `LOAD_FILTER;
            `LOAD_FILTER : ns = (offsetDone) ? `INITIAL_BUFFER_LOAD : `LOAD_FILTER;
            `INITIAL_BUFFER_LOAD : ns = (offsetDone == 1'b1) ? (initial_cnt == 2'd3) ? `WINDOW_LOAD : `INITIAL_SHIFT : `INITIAL_BUFFER_LOAD;
            `INITIAL_SHIFT : ns = `INITIAL_BUFFER_LOAD;
            `WINDOW_LOAD : ns = `CALC;
            `CALC : ns = (raDone) ? `STORE_RES_BUF : `CALC;
            `STORE_RES_BUF : ns = (rbFull) ? `STORE_TO_MEM : (mbcZero) ? (update_cnt == 4'd12) ? `LAST_STORING : `SHIFT_UPDATE : `WINDOW_LOAD;
            `STORE_TO_MEM : ns = (mbcZero) ? (update_cnt == 4'd12) ? `LAST_STORING : `SHIFT_UPDATE : `WINDOW_LOAD;
            `SHIFT_UPDATE : ns = `BUFFER_LOAD_UPDATE;
            `BUFFER_LOAD_UPDATE : ns = (offsetDone) ? `WINDOW_LOAD : `BUFFER_LOAD_UPDATE;
            `LAST_STORING : ns = `DONE;
        endcase
    end

    always @(*) begin
        offsetActive = 1'b0; offsetRst = 1'b0;
        memREn = 1'b0; memWEn = 1'b0; fblRst = 1'b0; fblAct = 1'b0; filBufRst = 1'b0; filBufLd = 1'b0; fillBufISel = 1'b0;
        mbRst = 1'b0; mbShift = 1'b0; mbWrite = 1'b0; mblRst = 1'b0; mblAct = 1'b0; mbcRst = 1'b0; mbcEn = 1'b0; rbClear = 1'b0;
        wbRst = 1'b0; wbLd = 1'b0; raAct = 1'b0; macRst = 1'b0; macAct = 1'b0; rbRst = 1'b0; rbEn = 1'b0; done = 1'b0; macClear = 1'b0;
        case(ps)
            `IDEL : begin
                offsetRst = 1'b1;
                fblRst    = 1'b1;
                filBufRst = 1'b1;
                mbRst     = 1'b1;
                mbcRst    = 1'b1;
                mblRst    = 1'b1;
                wbRst     = 1'b1;
                macRst    = 1'b1;
                rbRst     = 1'b1;
            end
            `LOAD_FILTER : begin
                offsetActive = 1'b1;
                offsetMode   = 2'b00; // reading filter
                baseAddrSel  = 2'b01; // base from y register
                memREn       = 1'b1;
                fblAct       = 1'b1;
                filBufLd     = 1'b1;
                fillBufISel  = 1'b1;
            end
            `INITIAL_BUFFER_LOAD : begin
                offsetActive = 1'b1;
                offsetMode   = 2'b10; // reading one line of picture from memory
                baseAddrSel  = 2'b00; // base from x register
                memREn       = 1'b1;
                mbWrite      = 1'b1;
                mblAct       = 1'b1;
            end
            `INITIAL_SHIFT : begin
                mbShift = 1'b1;
            end
            `WINDOW_LOAD : begin
                wbLd  = 1'b1;
                mbcEn = 1'b1;
            end
            `CALC : begin
                raAct  = 1'b1;
                macAct = 1'b1;
            end
            `STORE_RES_BUF : begin
                rbEn     = 1'b1;
                macClear = 1'b1;
            end
            `STORE_TO_MEM : begin
                offsetActive = 1'b1;
                offsetMode   = 2'b01; // get writing data offset
                baseAddrSel  = 2'b10; // base from z register
                memWEn       = 1'b1;
                rbClear      = 1'b1;
            end
            `SHIFT_UPDATE : begin
                mbShift = 1'b1;
            end
            `BUFFER_LOAD_UPDATE : begin
                offsetActive = 1'b1;
                offsetMode   = 2'b10; // reading one line of picture from memory
                baseAddrSel  = 2'b00; // base from x register
                memREn       = 1'b1;
                mbWrite      = 1'b1;
                mblAct       = 1'b1;
            end
            `LAST_STORING : begin
                offsetActive = 1'b1;
                offsetMode   = 2'b01; // get writing data offset
                baseAddrSel  = 2'b10; // base from z register
                memWEn       = 1'b1;
            end
            `DONE : begin
                done = 1'b1;
            end
        endcase
    end

endmodule
