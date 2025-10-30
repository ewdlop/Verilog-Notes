// Quine-McCluskey minimization example with 4 variables
// Function: f(a,b,c,d) with minterms: 0,1,2,5,6,7,8,9,14
// Minimized form: a'b' + b'c' + ac'd
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~a&~b) | (~b&~c) | (a&~c&d);
endmodule
