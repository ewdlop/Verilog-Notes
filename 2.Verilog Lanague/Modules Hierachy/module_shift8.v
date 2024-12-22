module top_module ( 
    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q 
);
    wire[7:0] w_q1;
    wire[7:0] w_q2;
    wire[7:0] w_q3;
    my_dff8 d_flip_flops1 (clk,d,w_q1);
    my_dff8 d_flip_flops2 (clk,w_q1,w_q2);
    my_dff8 d_flip_flops3 (clk,w_q2,w_q3);
    always@(*) begin
        case (sel)
            2'd3: q = w_q3;
            2'd2: q = w_q2;
            2'd1: q = w_q1;
            2'd0: q = d;
            default: q = 0;
        endcase
    end
    
endmodule
