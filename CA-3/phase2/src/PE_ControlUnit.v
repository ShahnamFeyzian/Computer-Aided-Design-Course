`define DONE  2'b00
`define CLEAR 2'b01
`define CALC  2'b10

module PE_ControlUnit(
    clk, rst, start,
    clear, active, done, idxI, idxJ 
);

    parameter KERNEL_SIZE = 4;

    input wire[0:0] clk, rst, start;
    
    output reg[0:0]  clear, active, done;
    output reg[31:0] idxI, idxJ;


    reg[1:0] ps, ns;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            ps <= `DONE;
        end
        else begin
            ps   <= ns;
            idxI <= (ps == `CLEAR) ? 32'b0  :
                    (idxJ == KERNEL_SIZE-1) ? (idxI == KERNEL_SIZE-1) ? 32'b0 : idxI+1 : idxI;
            
            idxJ <= (ps == `CLEAR) ? 32'b0  :
                    (idxJ == KERNEL_SIZE-1) ? 32'b0 : idxJ+1; 
        end
    end

    always @(*) begin
        case(ps)
            `DONE : ns = (start) ? `CLEAR : `DONE;
            `CLEAR: ns = `CALC;
            `CALC : ns = (idxI == KERNEL_SIZE-1 && idxJ == KERNEL_SIZE-1) ? `DONE : `CALC;
        endcase
    end

    always @(*) begin
        done   = 1'b0;
        clear  = 1'b0;
        active = 1'b0;
        case(ps)
            `DONE: begin
                done = 1'b1;
            end
            `CLEAR: begin
                 clear = 1'b1;
            end
            `CALC: begin
                active = 1'b1;
            end
        endcase
    end

endmodule
