`define IDLE        3'd0
`define LOAD_FILTER 3'd1
`define LOAD_BUFFER 3'd2
`define UPDATE_REGS 3'd3
`define WAIT        3'd4
`define DONE        3'd5

module Layer1ControlUnit(
    clk, rst, ldBuf, initLd,
    memIdx, idxI, idxJ, baseSel, bufWrEn, filWrEn, ldDone, done
);

    input wire[0:0] clk, rst, ldBuf, initLd;
    output reg[0:0] bufWrEn, baseSel, ldDone, done;
    output reg[3:0] filWrEn;
    output reg[31:0] memIdx, idxI, idxJ;

    reg[2:0] ps, ns;
    reg[1:0] row_cnt, col_cnt;
    reg[3:0] b_row, b_col;
    reg[5:0] fil_cnt;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            ps      <= `IDLE;
            fil_cnt <= 6'b0;
            row_cnt <= 2'b0;
            col_cnt <= 2'b0;
            b_row   <= 4'b0;
            b_col   <= 4'b0;
        end
        else begin
            ps      <= ns;
            fil_cnt <= (ps == `LOAD_FILTER) ? fil_cnt + 1 : fil_cnt;
            col_cnt <= (ps == `LOAD_BUFFER || ps == `LOAD_FILTER) ? col_cnt + 1 : col_cnt;
            row_cnt <= ((ps == `LOAD_BUFFER || ps == `LOAD_FILTER) && col_cnt == 2'd3) ? row_cnt + 1 : row_cnt;
            b_col   <= (ps == `UPDATE_REGS) ? (b_col == 4'd12) ? 4'b0 : b_col + 1 : b_col;
            b_row   <= (ps == `UPDATE_REGS && b_col == 4'd12) ? b_row + 1 : b_row; 
        end
    end

    always @(*) begin
        case(ps)
            `IDLE        : ns = (initLd) ? `IDLE : `LOAD_FILTER;
            `LOAD_FILTER : ns = (fil_cnt == 6'd63) ? `LOAD_BUFFER : `LOAD_FILTER;
            `LOAD_BUFFER : ns = (row_cnt == 2'd3 && col_cnt == 3'd3) ? `UPDATE_REGS : `LOAD_BUFFER;
            `UPDATE_REGS : ns = (b_row == 4'd12 && b_col == 4'd12) ? `DONE : `WAIT;
            `WAIT        : ns = (ldBuf) ? `LOAD_BUFFER : `WAIT;
        endcase
    end

    always @(*) begin
        memIdx  = 32'b0;   
        idxI    = {28'b0, row_cnt}; 
        idxJ    = {28'b0, col_cnt}; 
        bufWrEn = 1'b0; 
        filWrEn = 4'b0;   
        done    = 1'b0;    
        ldDone  = 1'b0;
        baseSel = 1'b0;
        case(ps)
            `LOAD_FILTER: begin
                filWrEn[0] = (fil_cnt <  6'd16) ? 1'b1 : 1'b0;
                filWrEn[1] = (fil_cnt <  6'd32) ? 1'b1 : 1'b0;
                filWrEn[2] = (fil_cnt <  6'd48) ? 1'b1 : 1'b0;
                filWrEn[3] = (fil_cnt <= 6'd63) ? 1'b1 : 1'b0;
                memIdx     = {26'b0, fil_cnt};
                baseSel    = 1'b0; // select y reg
            end
            `LOAD_BUFFER: begin
                bufWrEn = 1'b1;
                memIdx  = (b_row + row_cnt)*16 + (b_col + col_cnt);
                baseSel = 1'b1; // select x reg
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
