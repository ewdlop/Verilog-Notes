module top_module ( input clk, input d, output q );

    wire w_q1;
    wire w_q2;
    my_dff d_flip_flop1(clk, d, w_q1);
    my_dff d_flip_flop2(clk, w_q1, w_q2);
    my_dff d_flip_flop3(clk, w_q2, q);
    
endmodule