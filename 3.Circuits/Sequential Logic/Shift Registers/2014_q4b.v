module top_module (
    input [3:0] SW,
    input [3:0] KEY,//clk,E,L,w
    output [3:0] LEDR
); //
    MUXDFF dff3(SW[3],KEY[0],KEY[1],KEY[2],KEY[3],LEDR[3]);
    MUXDFF dff2(SW[2],KEY[0],KEY[1],KEY[2],LEDR[3],LEDR[2]);
    MUXDFF dff1(SW[1],KEY[0],KEY[1],KEY[2],LEDR[2],LEDR[1]);
    MUXDFF dff0(SW[0],KEY[0],KEY[1],KEY[2],LEDR[1],LEDR[0]);
endmodule

module MUXDFF(
    input R,
    input clk,
    input E,
    input L,
    input w,
	output Q
);
    always@(posedge clk)begin
        if(L) Q<=R;
        else if(E) Q<=w;
        else Q<=Q;
    end
endmodule
