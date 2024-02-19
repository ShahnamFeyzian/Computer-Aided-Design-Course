module Array_Multiplier(a, b, out);

    parameter N = 32;

    input wire signed [N-1:0] a, b;
    output wire[(2*N)-1:0] out;

    wire[N-1:0] p [0:N-1];
    wire[N-2:0] s [0:N-1];
    wire[N-2:0] c [0:N-1];

    genvar i, j;
    generate // generate products
        for(i=0; i<N; i=i+1) begin
            for(j=0; j<N; j=j+1) begin
                C_AND c_and(.a(a[i]), .b(b[j]), .out(p[i][j]));
            end
        end
    endgenerate

    generate // generate first row of FAs
        for(i=0; i<N-1; i=i+1) begin
            FA fa(.a(p[i+1][0]), .b(p[i][1]), .cin(1'b0), .s(s[0][i]), .cout(c[0][i]));
        end
    endgenerate

    generate // generate last col of FAs
        for(i=1; i<N-1; i=i+1)begin
            FA fa(.a(p[N-2][i+1]), .b(p[N-1][i]), .cin(c[i-1][N-2]), .s(s[i][N-2]), .cout(c[i][N-2]));
        end
    endgenerate

    generate // generate middle FAs
        for (i=1; i<N-1; i=i+1) begin
            for(j=0; j<N-2; j=j+1) begin
                FA fa(.a(p[j][i+1]), .b(s[i-1][j+1]), .cin(c[i-1][j]), .s(s[i][j]), .cout(c[i][j]));
            end             
        end
    endgenerate

    FA fa(.a(c[N-2][0]), .b(s[N-2][1]), .cin(1'b0), .s(s[N-1][0]), .cout(c[N-1][0])); // down right FA

    generate // generate middle of last row FAs
        for(i=1; i<N-2; i=i+1) begin
            FA fa(.a(c[N-2][i]), .b(s[N-2][i+1]), .cin(c[N-1][i-1]), .s(s[N-1][i]), .cout(c[N-1][i]));
        end
    endgenerate

    FA fa1(.a(p[N-1][N-1]), .b(c[N-2][N-2]), .cin(c[N-1][N-3]), .s(s[N-1][N-2]), .cout(c[N-1][N-2])); // down left FA

    assign out[0] = p[0][0]; // assign first bit
    
    generate // assign first N bits
        for(i=1; i<N; i=i+1) begin
            assign out[i] = s[i-1][0]; 
        end
    endgenerate

    generate // assign last N bits
        for(i=N; i<2*N-1; i=i+1) begin
            assign out[i] = s[N-1][i-N];
        end
    endgenerate
    
    assign out[2*N-1] = c[N-1][N-2]; // assign last bit

endmodule
