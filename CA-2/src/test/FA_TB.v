`timescale 1ns/1ns

module FA_TB();

    reg[0:0] a, b, cin;
    wire[0:0] s, cout;

    FA fa(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

    initial begin
        a=1'b0; b=1'b0; cin=1'b0;
        #5 a=1'b1; b=1'b0; cin=1'b0;
        #5 a=1'b0; b=1'b1; cin=1'b0;
        #5 a=1'b0; b=1'b0; cin=1'b1;
        #5 a=1'b1; b=1'b1; cin=1'b0;
        #5 a=1'b1; b=1'b0; cin=1'b1;
        #5 a=1'b0; b=1'b1; cin=1'b1;
        #5 a=1'b1; b=1'b1; cin=1'b1;        
        #5 $stop;
    end

endmodule
