module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);
    reg[31:0] previous;
    always@(posedge clk)begin
        previous <= in;
        if(reset) out<= 32'b0;
        else out <= out | (previous&~in);
    end
endmodule