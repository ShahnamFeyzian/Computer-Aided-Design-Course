`define IDEL                4'd0
`define LOAD_FILTER         4'd1
`define WAIT                4'd2
`define INITIAL_BUFFER_LOAD 4'd3
`define INITIAL_SHIFT       4'd4
`define WINDOW_LOAD         4'd5 
`define CALC                4'd6
`define STORE_RES_BUF       4'd7
`define STORE_TO_MEM        4'd8
`define SHIFT_UPDATE        4'd9
`define BUFFER_LOAD_UPDATE  4'd10
`define LAST_STORING        4'd11
`define DONE                4'd12

module PE_Controller(
    clk, rst, start, mbcZero, raDone, rbFull,
    fblRst, fblAct, filBufRst, filBufLd, fillBufISel,
    mbRst, mbShift, mbWrite, mblRst, mblAct, mbcRst, mbcEn, macClear, rbClear,
    wbRst, wbLd, raAct, macRst, macAct, rbRst, rbEn, done, storeToMemOut, bufLoadOut
);

    input wire[0:0] clk, rst, start, mbcZero, raDone, rbFull;

    output reg[0:0] fblRst, fblAct, filBufRst, filBufLd, fillBufISel,
                    mbRst, mbShift, mbWrite, mblRst, mblAct, mbcRst, mbcEn, macClear, rbClear,
                    wbRst, wbLd, raAct, macRst, macAct, rbRst, rbEn, done, storeToMemOut, bufLoadOut;

    reg[3:0] ps, ns;
    reg[1:0] buffer_load_cnt, load_cnt;
    reg[3:0] update_cnt;

    always @(posedge clk, posedge rst) begin
        if(rst) begin 
            ps              <= `IDEL; 
            buffer_load_cnt <= 2'b0; 
            update_cnt      <= 4'b0;
            load_cnt        <= 2'b0;
        end
        else begin
            ps              <= ns;
            load_cnt        <= (ps == `LOAD_FILTER || ps == `INITIAL_BUFFER_LOAD || ps == `BUFFER_LOAD_UPDATE) ? load_cnt + 1 : load_cnt;
            buffer_load_cnt <= (ps == `INITIAL_BUFFER_LOAD && load_cnt == 2'd3) ? buffer_load_cnt + 1 : buffer_load_cnt;
            update_cnt      <= (ps == `SHIFT_UPDATE) ? update_cnt + 1 : update_cnt;
        end
    end

    always @(*) begin
        case(ps)
            `IDEL                : ns = (rst) ? `IDEL : `LOAD_FILTER;
            `LOAD_FILTER         : ns = (load_cnt == 2'd3) ? `WAIT : `LOAD_FILTER;
            `WAIT                : ns = (start) ? `INITIAL_BUFFER_LOAD : `WAIT;
            `INITIAL_BUFFER_LOAD : ns = (load_cnt == 2'd3) ? (buffer_load_cnt == 2'd3) ? `WINDOW_LOAD : `INITIAL_SHIFT : `INITIAL_BUFFER_LOAD;
            `INITIAL_SHIFT       : ns = `INITIAL_BUFFER_LOAD;
            `WINDOW_LOAD         : ns = `CALC;
            `CALC                : ns = (raDone) ? `STORE_RES_BUF : `CALC;
            `STORE_RES_BUF       : ns = (rbFull) ? `STORE_TO_MEM : (mbcZero) ? (update_cnt == 4'd12) ? `LAST_STORING : `SHIFT_UPDATE : `WINDOW_LOAD;
            `STORE_TO_MEM        : ns = (mbcZero) ? (update_cnt == 4'd12) ? `LAST_STORING : `SHIFT_UPDATE : `WINDOW_LOAD;
            `SHIFT_UPDATE        : ns = `BUFFER_LOAD_UPDATE;
            `BUFFER_LOAD_UPDATE  : ns = (load_cnt == 2'd3) ? `WINDOW_LOAD : `BUFFER_LOAD_UPDATE;
            `LAST_STORING        : ns = `DONE;
        endcase
    end

    always @(*) begin
        fblRst = 1'b0; fblAct = 1'b0; filBufRst = 1'b0; filBufLd = 1'b0; fillBufISel = 1'b0;
        mbRst = 1'b0; mbShift = 1'b0; mbWrite = 1'b0; mblRst = 1'b0; mblAct = 1'b0; mbcRst = 1'b0; mbcEn = 1'b0; rbClear = 1'b0;
        wbRst = 1'b0; wbLd = 1'b0; raAct = 1'b0; macRst = 1'b0; macAct = 1'b0; rbRst = 1'b0; rbEn = 1'b0; done = 1'b0; macClear = 1'b0;
        storeToMemOut = 1'b0; bufLoadOut = 1'b0;
        case(ps)
            `IDEL : begin
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
                fblAct       = 1'b1;
                filBufLd     = 1'b1;
                fillBufISel  = 1'b1;
            end
            `INITIAL_BUFFER_LOAD : begin
                bufLoadOut   = 1'b1;
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
                storeToMemOut = 1'b1;
                rbClear       = 1'b1;
            end
            `SHIFT_UPDATE : begin
                mbShift = 1'b1;
            end
            `BUFFER_LOAD_UPDATE : begin
                bufLoadOut = 1'b1;
                mbWrite    = 1'b1;
                mblAct     = 1'b1;
            end
            `LAST_STORING : begin
                storeToMemOut = 1'b1;
            end
            `DONE : begin
                done = 1'b1;
            end
        endcase
    end

endmodule
