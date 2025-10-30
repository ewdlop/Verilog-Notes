// Quine-McCluskey minimization example with 3 variables
// Function: f(a,b,c) with minterms: 0,1,2,5,7
// Minimized form: a'b' + ac + bc
module top_module(
    input a,
    input b,
    input c,
    output out
);
    assign out = (~a&~b) | (a&c) | (b&c);
endmodule
