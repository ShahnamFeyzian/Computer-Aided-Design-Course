`define IDLE          4'd00
`define INIT_LOAD_L1  4'd02
`define UPDATE_BUF_L1 4'd03
`define WAIT_BUF_L1   4'd04
`define START_MAC_L1  4'd05
`define WAIT_MAC_L1   4'd06
`define STORE_MEM_L2  4'd07
`define INIT_LOAD_L2  4'd08
`define UPDATE_BUF_L2 4'd09
`define WAIT_BUF_L2   4'd10
`define START_MAC_L2  4'd11
`define WAIT_MAC_L2   4'd12
`define STORE_MEM_L3  4'd13
`define DONE          4'd14

module Controlelr(
    clk, rst, 
    
    ldBufL1, peStartL1, memWrEnL2, initLdL1, startLdPicL2, initLdL2, ldBufL2, peStartL2, memWrEnL3, done,
    
    ldBufDoneL1, ctrlDoneL1, peDoneL1, ldBufDoneL2, ctrlDoneL2, peDoneL2 
);

    input wire[0:0] clk, rst;
    
    input wire[0:0] 
        ldBufDoneL1, ctrlDoneL1, peDoneL1, 
        ldBufDoneL2, ctrlDoneL2, peDoneL2;

    output reg[0:0] 
        ldBufL1, peStartL1, memWrEnL2, 
        initLdL1, startLdPicL2, initLdL2, ldBufL2,
        peStartL2, memWrEnL3, done;


    reg[3:0] ps, ns;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            ps <= `IDLE;
        end
        else begin
            ps <= ns;
        end
    end

    always @(*) begin
        case(ps)
            `IDLE          : ns = (rst) ? `IDLE : `INIT_LOAD_L1;
            `INIT_LOAD_L1  : ns = `WAIT_BUF_L1;
            `UPDATE_BUF_L1 : ns = `WAIT_BUF_L1;
            `WAIT_BUF_L1   : ns = (ldBufDoneL1) ? `START_MAC_L1 : `WAIT_BUF_L1;
            `START_MAC_L1  : ns = `WAIT_MAC_L1;
            `WAIT_MAC_L1   : ns = (peDoneL1) ? `STORE_MEM_L2 : `WAIT_MAC_L1;
            `STORE_MEM_L2  : ns = (ctrlDoneL1) ? `INIT_LOAD_L2 : `UPDATE_BUF_L1;
            `INIT_LOAD_L2  : ns = `WAIT_BUF_L2;
            `UPDATE_BUF_L2 : ns = `WAIT_BUF_L2;
            `WAIT_BUF_L2   : ns = (ldBufDoneL2) ? `START_MAC_L2 : `WAIT_BUF_L2;
            `START_MAC_L2  : ns = `WAIT_MAC_L2;
            `WAIT_MAC_L2   : ns = (peDoneL2) ? `STORE_MEM_L3 : `WAIT_MAC_L2;
            `STORE_MEM_L3  : ns = (ctrlDoneL2) ? `DONE : `UPDATE_BUF_L2;
        endcase
    end

    always @(*) begin
        ldBufL1      = 1'b0; 
        peStartL1    = 1'b0; 
        memWrEnL2    = 1'b0;   
        initLdL1     = 1'b0; 
        startLdPicL2 = 1'b0; 
        initLdL2     = 1'b0; 
        ldBufL2      = 1'b0;
        peStartL2    = 1'b0; 
        memWrEnL3    = 1'b0;
        done         = 1'b0;
        case(ps)
            `INIT_LOAD_L1: begin
                initLdL1     = 1'b1;
                startLdPicL2 = 1'b1;
            end
            `UPDATE_BUF_L1: begin
                ldBufL1 = 1'b1;
            end
            `START_MAC_L1: begin
                peStartL1 = 1'b1;
            end
            `STORE_MEM_L2: begin
                memWrEnL2 = 1'b1;
            end
            `INIT_LOAD_L2: begin
                initLdL2 = 1'b1;
            end
            `UPDATE_BUF_L2: begin
                ldBufL2 = 1'b1;
            end
            `START_MAC_L2: begin
                peStartL2 = 1'b1;
            end
            `STORE_MEM_L3: begin
                memWrEnL3 = 1'b1;
            end
            `DONE: begin
                done = 1'b1;
            end
        endcase
    end

endmodule
