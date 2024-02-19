module RO_Memory(read_en, addr, val_out);

    input wire[0:0] read_en;
    input wire[1:0] addr;

    output wire[31:0] val_out;

    reg[31:0] mem [3:0];

    initial begin
        mem[0] <= 32'b00111110010011001100110011001101; // 0.2
        mem[1] <= 32'b00111110110011001100110011001101; // 0.4
        mem[2] <= 32'b00111111000110011001100110011010; // 0.6
        mem[3] <= 32'b00111111010011001100110011001101; // 0.8
    end

    assign val_out = (read_en) ? mem[addr] : 32'bz;

endmodule
