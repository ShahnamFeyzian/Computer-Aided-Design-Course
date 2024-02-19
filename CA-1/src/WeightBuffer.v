module WeightBuffer(weights);

    output reg[31:0] weights [0:9];

    initial begin
        // weights' buffer in order  (0->w00) (1->w01) (2->w02) (3->w03) (4->w11) (5->w12) (6->w13) (7->w22) (8->w23) (9->w33)
        weights[0] = 32'b00111111100000000000000000000000; // 1
        weights[1] = 32'b10111110010011001100110011001101; // -0.2
        weights[2] = 32'b10111110010011001100110011001101; // -0.2
        weights[3] = 32'b10111110010011001100110011001101; // -0.2
        weights[4] = 32'b00111111100000000000000000000000; // 1
        weights[5] = 32'b10111110010011001100110011001101; // -0.2
        weights[6] = 32'b10111110010011001100110011001101; // -0.2
        weights[7] = 32'b00111111100000000000000000000000; // 1
        weights[8] = 32'b10111110010011001100110011001101; // -0.2
        weights[9] = 32'b00111111100000000000000000000000; // 1
    end

endmodule
