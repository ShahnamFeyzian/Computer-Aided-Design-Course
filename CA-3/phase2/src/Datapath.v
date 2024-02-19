module Datapath(
    clk, rst, 
    
    ldBufL1, peStartL1, memWrEnL2, initLdL1, startLdPicL2, initLdL2, ldBufL2, peStartL2, memWrEnL3,
    
    ldBufDoneL1, ctrlDoneL1, peDoneL1, ldBufDoneL2, ctrlDoneL2, peDoneL2 
);

    parameter X = 0, Y = 0,
              Z = 0, M = 0;

    input wire[0:0] 
        clk, rst, ldBufL1, peStartL1, memWrEnL2, 
        initLdL1, startLdPicL2, initLdL2, ldBufL2,
        peStartL2, memWrEnL3;

    output wire[0:0] 
        ldBufDoneL1, ctrlDoneL1, peDoneL1, 
        ldBufDoneL2, ctrlDoneL2, peDoneL2;

    reg[31:0] x_reg, y_reg, z_reg, m_reg;
    initial begin
        x_reg = X*4;
        y_reg = Y*4;
        z_reg = Z*4;
        m_reg = M*4;
    end    


    wire[31:0] input_mem_offset, idxIL1, idxJL1;
    wire[0:0]  buf_wr_en_L1, base_sel_L1;
    wire[3:0]  fil_wr_en_L1;
    Layer1ControlUnit L1_control_unit(
        .clk(clk),              .rst(rst), 
        .ldBuf(ldBufL1),        .memIdx(input_mem_offset), 
        .idxI(idxIL1),          .idxJ(idxJL1), 
        .bufWrEn(buf_wr_en_L1), .filWrEn(fil_wr_en_L1), 
        .ldDone(ldBufDoneL1),   .done(ctrlDoneL1),
        .baseSel(base_sel_L1),  .initLd(initLdL1)
    );


    wire[31:0] input_mem_base = (base_sel_L1 == 1'b0) ? y_reg : x_reg;
    wire[31:0] input_mem_addr = input_mem_base + input_mem_offset;
    wire[7:0] input_mem_out;
    Memory #(.TYPE(5), .READ_ADDR(0)) 
    input_mem(
        .clk(clk),               .rEn(1'b1), 
        .wEn(1'b0),              .dataIn(8'bz), 
        .addrIn(input_mem_addr), .dataOut(input_mem_out)
    );


    wire[7:0] pe_L1_out [0:3];
    wire[0:0] pe_L1_done[0:3];
    wire[0:7] pe_data_in_L1 [0:0];
    assign pe_data_in_L1[0] = input_mem_out;
    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin
            PE #(.KERNEL_SIZE(4), .MAC_NUM(1), .UPPER_BIT(11)) 
            pe_L1(
                .clk(clk),                    .rst(rst), 
                .start(peStartL1),            .picWrEn(buf_wr_en_L1), 
                .shiftUp(1'b0),               .shiftLeft(1'b0), 
                .filterWrEn(fil_wr_en_L1[i]), .idxI(idxIL1), 
                .idxJ(idxJL1),                .bufDataIn(pe_data_in_L1),
                .filDataIn(input_mem_out),
                .done(pe_L1_done[i]),         .dataOut(pe_L1_out[i])
            );
        end
    endgenerate
    assign peDoneL1 = &{pe_L1_done[0], pe_L1_done[1], pe_L1_done[2], pe_L1_done[3]};


    wire[0:0]  buf_wr_en_L2, base_sel_L2;
    wire[31:0] mem_offset_L2, idxIL2, idxJL2;
    wire[3:0]  fil_wr_en_L2;
    Layer2ControlUnit L2_conttrol_unit(
        .clk(clk),                 .rst(rst), 
        .startLdPic(startLdPicL2), .ldPic(memWrEnL2), 
        .ldBuf(ldBufL2),           .initLd(initLdL2),
        .memIdx(mem_offset_L2),    .idxI(idxIL2), 
        .idxJ(idxJL2),             .baseSel(base_sel_L2), 
        .bufWrEn(buf_wr_en_L2),    .filWrEn(fil_wr_en_L2), 
        .ldDone(ldBufDoneL2),      .done(ctrlDoneL2)
    );


    wire[31:0] mem_base_L2 = (base_sel_L2) ? m_reg : z_reg;
    wire[31:0] mem_addr_L2 = mem_base_L2 + mem_offset_L2;
    wire[7:0]  mem_out_L2 [0:3];
    generate
        for(i=0; i<4; i=i+1) begin
            Memory #(.TYPE(i+1), .READ_ADDR(M)) 
            out_mem(
                .clk(clk),            .rEn(1'b1), 
                .wEn(memWrEnL2),      .dataIn(pe_L1_out[i]), 
                .addrIn(mem_addr_L2), .dataOut(mem_out_L2[i])
            );
        end
    endgenerate


    wire[7:0] pe_L2_out [0:3];
    wire[0:0] pe_L2_done[0:3];
    wire[0:7] pe_data_in_L2 [0:3];
    generate
        for(i=0; i<4; i=i+1) begin
            assign pe_data_in_L2[i] = mem_out_L2[i];
            PE #(.KERNEL_SIZE(4), .MAC_NUM(4), .UPPER_BIT(11)) 
            pe_L2(
                .clk(clk),                    .rst(rst), 
                .start(peStartL2),            .picWrEn(buf_wr_en_L2), 
                .shiftUp(1'b0),               .shiftLeft(1'b0), 
                .filterWrEn(fil_wr_en_L2),    .idxI(idxIL2), 
                .idxJ(idxJL2),                .bufDataIn(pe_data_in_L2),
                .filDataIn(mem_out_L2[i]),
                .done(pe_L2_done[i]),         .dataOut(pe_L2_out[i])
            );
        end
    endgenerate
    assign peDoneL2 = &{pe_L2_done[0], pe_L2_done[1], pe_L2_done[2], pe_L2_done[3]};

    reg[31:0] addr_L3;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            addr_L3 <= 32'b0;
        end
        else begin
            addr_L3 <= (memWrEnL3) ? addr_L3 + 1 : addr_L3;
        end
    end

    generate
        for(i=0; i<4; i=i+1) begin
            Memory #(.TYPE(0), .READ_ADDR(0)) 
            res_mem(
                .clk(clk),        .rEn(1'b1), 
                .wEn(memWrEnL3),  .dataIn(pe_L2_out[i]), 
                .addrIn(addr_L3), .dataOut()
            );
        end
    endgenerate    

endmodule
