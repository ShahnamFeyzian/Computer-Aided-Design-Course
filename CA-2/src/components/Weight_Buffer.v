`define DEFUALT_WEIGHT 5'b11110
`define OWN_WEIGHT     5'b01000

module Weight_Buffer(clk, weights);

    input wire[0:0] clk;
    output wire[4:0] weights [0:9];

    E_REG #(5) reg0(.clk(clk), .rst(1'b0), .en(1'b1), .in(`OWN_WEIGHT),     .out(weights[0])); // w00
    E_REG #(5) reg1(.clk(clk), .rst(1'b0), .en(1'b1), .in(`DEFUALT_WEIGHT), .out(weights[1])); // w01
    E_REG #(5) reg2(.clk(clk), .rst(1'b0), .en(1'b1), .in(`DEFUALT_WEIGHT), .out(weights[2])); // w02
    E_REG #(5) reg3(.clk(clk), .rst(1'b0), .en(1'b1), .in(`DEFUALT_WEIGHT), .out(weights[3])); // w03
    E_REG #(5) reg4(.clk(clk), .rst(1'b0), .en(1'b1), .in(`OWN_WEIGHT),     .out(weights[4])); // w11
    E_REG #(5) reg5(.clk(clk), .rst(1'b0), .en(1'b1), .in(`DEFUALT_WEIGHT), .out(weights[5])); // w12
    E_REG #(5) reg6(.clk(clk), .rst(1'b0), .en(1'b1), .in(`DEFUALT_WEIGHT), .out(weights[6])); // w13
    E_REG #(5) reg7(.clk(clk), .rst(1'b0), .en(1'b1), .in(`OWN_WEIGHT),     .out(weights[7])); // w22
    E_REG #(5) reg8(.clk(clk), .rst(1'b0), .en(1'b1), .in(`DEFUALT_WEIGHT), .out(weights[8])); // w23
    E_REG #(5) reg9(.clk(clk), .rst(1'b0), .en(1'b1), .in(`OWN_WEIGHT),     .out(weights[9])); // w33

endmodule
