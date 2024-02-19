`define IDLE         3'd0
`define SYC_STATE    3'd1     
`define LOAD_FILTERS 3'd2 
`define WAIT         3'd3
`define DONE         3'd4

module Controller(
    clk, rst, peRstOut, peStartOut, xEnOut, yEnOut, zEnOut, dataMemAddrSelOut, resMemWrEnOut,
    done, peDoneIn, storeToMemIn, bufLoadIn
);

    parameter N = 4;

    input wire[0:0] clk, rst, peDoneIn, storeToMemIn, bufLoadIn;
    output reg[0:0] done, peStartOut, xEnOut, yEnOut, zEnOut, 
                    dataMemAddrSelOut, resMemWrEnOut;
    output reg[N-1:0] peRstOut;

    reg[2:0] ps, ns;
    reg[1:0] filter_ld_cnt;
    reg[31:0] pe_ld_cnt;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            ps <= `IDLE;
            filter_ld_cnt <= 2'b0;
            pe_ld_cnt <= 32'b0;
        end
        else begin
            ps <= ns;
            filter_ld_cnt <= (ps == `LOAD_FILTERS) ? filter_ld_cnt + 1 : filter_ld_cnt;
            pe_ld_cnt <= (ps == `LOAD_FILTERS && filter_ld_cnt == 2'd3) ? pe_ld_cnt + 1 : pe_ld_cnt;
        end
    end

    always @(*) begin
        case(ps)
            `IDLE         : ns = (rst) ? `IDLE : `SYC_STATE;
            `SYC_STATE    : ns = `LOAD_FILTERS;
            `LOAD_FILTERS : ns = (filter_ld_cnt == 2'd3 && pe_ld_cnt == N-1) ? `WAIT : `LOAD_FILTERS;
            `WAIT         : ns = (peDoneIn) ? `DONE : `WAIT;
        endcase
    end

    integer i;
    always @(*) begin 
        done = 1'b0; xEnOut = 1'b0; yEnOut = 1'b0; zEnOut = 1'b0; 
        dataMemAddrSelOut = 1'b0; resMemWrEnOut = 1'b0;
        peStartOut=1'b0;
        
        for(i=0; i<N; i=i+1) begin
            peRstOut[i] = (pe_ld_cnt >= i) ? 1'b0 : 
                          (pe_ld_cnt == (i-1) && filter_ld_cnt == 2'd3) ? 1'b0 : 1'b1; 
        end
        case(ps)
            `IDLE: begin
                peRstOut = {N{1'b1}};
            end
            `LOAD_FILTERS: begin
                dataMemAddrSelOut = 1'b0; // select y register
                yEnOut = 1'b1;
            end
            `WAIT: begin
                peStartOut        = 1'b1;
                resMemWrEnOut     = (storeToMemIn) ? 1'b1 : 1'b0;
                zEnOut            = (storeToMemIn) ? 1'b1 : 1'b0;
                dataMemAddrSelOut = (bufLoadIn) ? 1'b1 : 1'b0;
                xEnOut            = (bufLoadIn) ? 1'b1 : 1'b0;
            end
            `DONE: begin
                done = 1'b1;
            end
        endcase
    end

endmodule
