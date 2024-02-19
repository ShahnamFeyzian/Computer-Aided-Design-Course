`define IDLE         4'd0
`define MEM_L0       4'd1
`define MEM_L1       4'd2
`define MEM_L2       4'd3
`define MEM_L3       4'd4
`define PU_MULT      4'd5
`define PU_ADD       4'd6
`define UPDATE_REGS  4'd7
`define FIND_ANS     4'd8
`define ANS0         4'd9
`define ANS1        4'd10
`define ANS2        4'd11
`define ANS3        4'd12
`define DONE        4'd13

module ControlUnit(
    clk, rst,
    pu0_z, pu1_z, pu2_z, pu3_z, end_signal, 
    addr_mux, addr_rst, addr_cnt_en, addr_set, mem_r_en, a_muxs, 
    a0_reg_en, a1_reg_en, a2_reg_en, a3_reg_en,
    pu_mult_regs_en, pu_add_regs_en, done
);

    input wire[0:0] clk, rst; 
    input wire[0:0] pu0_z, pu1_z, pu2_z, pu3_z, end_signal;

    output reg[0:0] addr_rst, addr_cnt_en, addr_set, mem_r_en, a_muxs, 
                    a0_reg_en, a1_reg_en, a2_reg_en, a3_reg_en, done,
                    pu_mult_regs_en, pu_add_regs_en;
    output reg[1:0] addr_mux;

    reg[3:0] ps, ns;


    // sequential updating present state
    always@(posedge clk, posedge rst) begin
        if(rst) ps <= `IDLE;
        else    ps <= ns;
    end


    // combinational next state logic
    always@(
        pu0_z, pu1_z, pu2_z, pu3_z, end_signal, ps, rst
    ) 
    begin

        case (ps)
            `IDLE        : ns = (rst) ? `IDLE : `MEM_L0;
            `MEM_L0      : ns = `MEM_L1;
            `MEM_L1      : ns = `MEM_L2;
            `MEM_L2      : ns = `MEM_L3;
            `MEM_L3      : ns = `PU_MULT;
            `PU_MULT     : ns = `PU_ADD;
            `PU_ADD      : ns = `UPDATE_REGS;
            `UPDATE_REGS : ns = (end_signal) ? `FIND_ANS : `PU_MULT;
            `FIND_ANS    : ns = (~pu0_z) ? `ANS0 :
                                (~pu1_z) ? `ANS1 :
                                (~pu2_z) ? `ANS2 : `ANS3;
            `ANS0        : ns = `DONE; 
            `ANS1        : ns = `DONE; 
            `ANS2        : ns = `DONE; 
            `ANS3        : ns = `DONE;
            `DONE        : ns = `DONE;
            default      : ns = `IDLE; 
        endcase

    end

  
    // combinational signals issuing
    always@(ps)
    begin
        addr_mux  = 1'b0; addr_rst  = 1'b0; addr_cnt_en     = 1'b0; addr_set       = 1'b0; 
        mem_r_en  = 1'b0; a_muxs    = 1'b0; a0_reg_en       = 1'b0; a1_reg_en      = 1'b0;       
        a2_reg_en = 1'b0; a3_reg_en = 1'b0; pu_mult_regs_en = 1'b0; pu_add_regs_en = 1'b0;

        case (ps)
            `IDLE : 
            begin
                addr_rst = 1'b1;
                done = 1'b0;
            end
            `MEM_L0 : 
            begin
                a_muxs      = 1'b1;
                a0_reg_en   = 1'b1;
                mem_r_en    = 1'b1;
                addr_cnt_en = 1'b1;    
            end

            `MEM_L1 : 
            begin
                a_muxs      = 1'b1;
                a1_reg_en   = 1'b1;
                mem_r_en    = 1'b1;
                addr_cnt_en = 1'b1;    
            end

            `MEM_L2 : 
            begin
                a_muxs      = 1'b1;
                a2_reg_en   = 1'b1;
                mem_r_en    = 1'b1;
                addr_cnt_en = 1'b1;    
            end

            `MEM_L3 : 
            begin
                a_muxs      = 1'b1;
                a3_reg_en   = 1'b1;
                mem_r_en    = 1'b1;
                addr_cnt_en = 1'b1;    
            end

            `PU_MULT : pu_mult_regs_en = 1'b1;

            `PU_ADD  : pu_add_regs_en = 1'b1;

            `UPDATE_REGS : 
            begin
                a0_reg_en = 1'b1;
                a1_reg_en = 1'b1;
                a2_reg_en = 1'b1;
                a3_reg_en = 1'b1;
            end

            `FIND_ANS : ;

            `ANS0 : 
            begin
                addr_set =  1'b1;
                addr_mux = 2'b00;
            end
            
            `ANS1 : 
            begin
                addr_set =  1'b1;
                addr_mux = 2'b01;
            end
            
            `ANS2 : 
            begin
                addr_set =  1'b1;
                addr_mux = 2'b10;
            end

            `ANS3 : 
            begin
                addr_set =  1'b1;
                addr_mux = 2'b11;
            end

            `DONE :
            begin
                mem_r_en = 1'b1;
                done     = 1'b1;
            end
        endcase
    end

endmodule
