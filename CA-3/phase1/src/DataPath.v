module DataPath(
    clk, rst, xEnIn, yEnIn, zEnIn, dataMemAddrSelIn, resMemWrEnIn, peStart, peRstIn,
    peDoneOut, storeToMemOut, bufLoadOut
);

    parameter N = 4;

    input wire[0:0] clk, rst, xEnIn, yEnIn, zEnIn, 
                    dataMemAddrSelIn, resMemWrEnIn, peStart;
    input wire[N-1:0] peRstIn;
    output wire[0:0] peDoneOut, storeToMemOut, bufLoadOut;

    reg[31:0] x_reg, y_reg, z_reg,
              x_cnt, y_cnt, z_cnt;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            x_reg <= 32'd16; // address of picture
            y_reg <= 32'd0;  // address of kernels
            z_reg <= 32'd0;  // address of storing result
            x_cnt <= 32'd0;
            y_cnt <= 32'd0;
            z_cnt <= 32'd0;
        end
        else begin
            x_cnt <= (xEnIn) ? x_cnt + 1: x_cnt;
            y_cnt <= (yEnIn) ? y_cnt + 1: y_cnt;
            z_cnt <= (zEnIn) ? z_cnt + 1: z_cnt;
        end
    end

    wire[31:0] data_mem_address = (dataMemAddrSelIn == 1'b1) ? (x_reg + x_cnt) : (y_reg + y_cnt);
    wire[31:0] data_mem_out;
    DataMemory data_memory(
        // picture and kernels are stored in this memory
        .clk(clk),                 .rEn(1'b1), 
        .wEn(1'b0),                .dataIn(32'bz), 
        .addrIn(data_mem_address), .dataOut(data_mem_out)
    );

    wire[N-1:0]  pe_done, pe_store_to_mem, pe_buf_load;
    wire[31:0] pe_res_out [0:N-1];
    genvar i;
    generate
        for (i=0; i<N; i=i+1) begin
            PE pe(
                // result calculation unit
                .clk(clk),                          .rst(peRstIn[i]), 
                .memoryIn(data_mem_out),            .startIn(peStart), 
                .done(pe_done[i]),                  .resOut(pe_res_out[i]), 
                .storeToMemOut(pe_store_to_mem[i]), .bufLoadOut(pe_buf_load[i])
            );

            ResMemory res_memory(
                // result storage memory
                .clk(clk),              .rEn(1'b0), 
                .wEn(resMemWrEnIn),     .dataIn(pe_res_out[i]), 
                .addrIn(z_reg + z_cnt), .dataOut()
            );
        end
    endgenerate

    assign peDoneOut      = pe_done[0];
    assign  storeToMemOut = pe_store_to_mem[0];
    assign bufLoadOut     = pe_buf_load[0];

endmodule
