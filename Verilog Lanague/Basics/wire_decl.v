`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 

	wire and_or;
    assign out = and_or;
    assign out_n = ~and_or;
    assign and_or = (a&b)|(c&d);
    
endmodule