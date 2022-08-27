module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);
    reg[3:0] Q;
    always@(posedge clk)begin
        Q[0] <= (resetn) ? in : 1'b0;
        Q[1] <= (resetn) ? Q[0] : 1'b0;
        Q[2] <= (resetn) ? Q[1] : 1'b0;
        out <= (resetn) ? Q[2] : 1'b0;
    end
endmodule