module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire[31:0] invert;
    assign invert = sub == 1? ~b:b;
	wire cout;
    add16 adder1(a[15:0],invert[15:0],sub,sum[15:0],cout);
    add16 adder2(a[31:16],invert[31:16],cout,sum[31:16]);
    
endmodule
