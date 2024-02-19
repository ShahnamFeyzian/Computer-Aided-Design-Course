`define READING_FILTER 2'b00
`define STORING_DATA   2'b01
`define READING_LINE   2'b10

module OffsetGenerator(clk, rst, active, mode, val_out, done);

    input wire[0:0] clk, rst, active;
    input wire[1:0] mode;

    output reg[0:0] done;
    output wire[31:0] val_out;

    reg[31:0] filter_cnt, buffer_cnt, store_cnt;

    always @(posedge clk, posedge rst) begin
      if(rst) begin
        filter_cnt <= 32'b0;
        buffer_cnt <= 32'b0;
        store_cnt  <= 32'b0;
      end
      else if(active) begin
        if(mode == `READING_FILTER) begin
            filter_cnt <= filter_cnt + 1;
        end
        if(mode == `STORING_DATA) begin
            store_cnt <= store_cnt + 1;
        end
        if(mode == `READING_LINE) begin
            buffer_cnt <= buffer_cnt + 1;
        end
      end
    end

    always @(*) begin
        done = 1'b0;
        if(active == 1'b0 || rst == 1'b1) done = 1'b1;
        else if(mode == `READING_FILTER && filter_cnt == 32'd3) done = 1'b1;
        else if(mode == `READING_LINE && buffer_cnt[1:0] == 2'b11) done = 1'b1;
    end

    assign val_out = (mode == `READING_FILTER) ? filter_cnt : 
                     (mode == `STORING_DATA)   ? store_cnt  : 
                     (mode == `READING_LINE)   ? buffer_cnt : 32'bz;

endmodule