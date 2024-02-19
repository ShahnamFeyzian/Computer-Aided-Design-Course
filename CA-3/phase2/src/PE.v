module PE(clk, rst, start, picWrEn, shiftUp, shiftLeft, filterWrEn, idxI, idxJ, bufDataIn, filDataIn, done, dataOut);

    parameter KERNEL_SIZE =  4, 
              MAC_NUM     =  1,
              UPPER_BIT   = 11;

    input wire[0:0]  clk, rst, start, picWrEn, shiftUp, shiftLeft;
    input wire[MAC_NUM-1:0] filterWrEn;
    input wire[31:0] idxI, idxJ;
    input wire[7:0]  filDataIn;
    input wire[7:0]  bufDataIn [0:MAC_NUM-1];
    output wire[0:0] done;
    output wire[7:0] dataOut;

    
    wire[0:0]  ctrl_clear, ctrl_active;
    wire[31:0] ctrl_idx_i, ctrl_idx_j;
    PE_ControlUnit #(.KERNEL_SIZE(KERNEL_SIZE)) control_unit(
        .clk(clk),            .rst(rst), 
        .start(start),        .clear(ctrl_clear), 
        .active(ctrl_active), .done(done), 
        .idxI(ctrl_idx_i),    .idxJ(ctrl_idx_j) 
    );


    wire[0:0] fil_wr_en = |filterWrEn;
    wire[31:0] final_i = (picWrEn || fil_wr_en) ? idxI : ctrl_idx_i;  
    wire[31:0] final_j = (picWrEn || fil_wr_en) ? idxJ : ctrl_idx_j;


    wire[7:0] buf_out [0:MAC_NUM-1];
    wire[7:0] fil_out [0:MAC_NUM-1];
    genvar i;
    generate
        for(i=0; i<MAC_NUM; i=i+1) begin
            Buffer #(.SIZE(KERNEL_SIZE)) filter(
                .clk(clk), 
                .rst(1'b0),         .shiftUp(1'b0), 
                .shiftLeft(1'b0),   .wrEn(filterWrEn[i]), 
                .idxI(final_i),     .idxJ(final_j), 
                .dataIn(filDataIn), .dataOut(fil_out[i])
            );

            Buffer #(.SIZE(KERNEL_SIZE)) buffer(
                .clk(clk), 
                .rst(1'b0),            .shiftUp(shiftUp), 
                .shiftLeft(shiftLeft), .wrEn(picWrEn), 
                .idxI(final_i),        .idxJ(final_j), 
                .dataIn(bufDataIn[i]), .dataOut(buf_out[i])
            );
        end
    endgenerate


    wire[31:0] mac_out[0:MAC_NUM-1];
    generate
        for(i=0; i<MAC_NUM; i=i+1) begin
            MAC mac(
                .clk(clk), 
                .rst(1'b0),          .active(ctrl_active), 
                .clear(ctrl_clear),  .val1In(fil_out[i]), 
                .val2In(buf_out[i]), .valOut(mac_out[i])
            );
        end
    endgenerate


    wire[31:0] total_sum;
    Adder #(.N(MAC_NUM)) adder(.dataIn(mac_out), .dataOut(total_sum));

    assign dataOut = total_sum[UPPER_BIT:UPPER_BIT-7];

endmodule
