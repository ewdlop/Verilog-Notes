module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    reg[7:0] previous;
    always@(posedge clk)begin
    	previous <= in;
        anyedge <= previous ^ in;
    end
endmodule