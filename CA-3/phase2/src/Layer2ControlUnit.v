`define IDLE        3'd0 
`define STORE_PIC   3'd1 
`define LOAD_FILTER 3'd2 
`define LOAD_BUFFER 3'd3 
`define UPDATE_REGS 3'd4 
`define WAIT        3'd5 
`define DONE        3'd6 

module Layer2ControlUnit(
    clk, rst, startLdPic, ldPic, ldBuf, initLd,
    memIdx, idxI, idxJ, baseSel, bufWrEn, filWrEn, ldDone, done
);

    input wire[0:0] clk, rst, startLdPic, ldPic, ldBuf, initLd;

    output reg[0:0]  baseSel, bufWrEn, ldDone, done;
    output reg[31:0] memIdx, idxI, idxJ;
    output reg[3:0]  filWrEn;

    reg[2:0]  ps, ns;
    reg[31:0] pic_ld_cnt;
    reg[5:0]  fil_ld_cnt;
    reg[1:0]  row_cnt, col_cnt;
    reg[3:0]  b_row, b_col; 

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            ps         <= `IDLE;
            pic_ld_cnt <= 32'b0;
            fil_ld_cnt <=  6'b0;
            row_cnt    <=  2'b0;
            col_cnt    <=  2'b0;
            b_row      <=  4'b0;
            b_col      <=  4'b0;
        end
        else begin
            ps         <= ns;
            pic_ld_cnt <= (ps == `STORE_PIC && ldPic == 1'b1) ? pic_ld_cnt + 1 : pic_ld_cnt;
            fil_ld_cnt <= (ps == `LOAD_FILTER) ? fil_ld_cnt + 1 : fil_ld_cnt;
            col_cnt    <= (ps == `LOAD_FILTER || ps == `LOAD_BUFFER) ? col_cnt + 1 : col_cnt;
            row_cnt    <= ((ps == `LOAD_FILTER || ps == `LOAD_BUFFER) && col_cnt == 2'd3) ? row_cnt + 1 : row_cnt;
            b_col      <= (ps == `UPDATE_REGS) ? (b_col == 4'd9) ? 4'b0 : b_col + 1 : b_col;
            b_row      <= (ps == `UPDATE_REGS && b_col == 4'd9) ? b_row + 1 : b_row;
        end
    end

    always @(*) begin
        case(ps)
            `IDLE        : ns = (startLdPic) ? `STORE_PIC : `IDLE;
            `STORE_PIC   : ns = (initLd) ? `LOAD_FILTER : `STORE_PIC;
            `LOAD_FILTER : ns = (fil_ld_cnt == 6'd63) ? `LOAD_BUFFER : `LOAD_FILTER;
            `LOAD_BUFFER : ns = (row_cnt == 2'd3 && col_cnt == 2'd3) ? `UPDATE_REGS : `LOAD_BUFFER;
            `UPDATE_REGS : ns = (b_row == 4'd9 && b_col == 4'd9) ? `DONE : `WAIT;
            `WAIT        : ns = (ldBuf) ? `LOAD_BUFFER : `WAIT;
        endcase
    end

    integer i;
    always @(*) begin
        baseSel = 1'b0; 
        bufWrEn = 1'b0; 
        ldDone  = 1'b0; 
        done    = 1'b0;
        idxI    = {28'b0, row_cnt}; 
        idxJ    = {28'b0, col_cnt}; 
        memIdx  = 32'b0;
        filWrEn = 4'b0;
        case(ps)
            `STORE_PIC: begin
                memIdx  = pic_ld_cnt;
                baseSel = 1'b0; // select z reg
            end
            `LOAD_FILTER: begin
                filWrEn[0] = (fil_ld_cnt <  6'd16) ? 1'b1 : 1'b0;
                filWrEn[1] = (fil_ld_cnt <  6'd32) ? 1'b1 : 1'b0;
                filWrEn[2] = (fil_ld_cnt <  6'd48) ? 1'b1 : 1'b0;
                filWrEn[3] = (fil_ld_cnt <= 6'd63) ? 1'b1 : 1'b0;
                memIdx     = {26'b0, fil_ld_cnt};
                baseSel    = 1'b1; // select m reg
            end
            `LOAD_BUFFER: begin
                bufWrEn = 1'b1;
                memIdx  = (b_row + row_cnt)*13 + (b_col + col_cnt);
                baseSel = 1'b0; // select z reg
            end
            `WAIT: begin
                ldDone = 1'b1;
            end
            `DONE: begin
                done   = 1'b1;
                ldDone = 1'b1;
            end
        endcase
    end

endmodule
