// Quine-McCluskey minimization example with 4 variables (complex)
// Function: f(a,b,c,d) with minterms: 1,3,4,5,6,7,10,12,13
// Minimized form: a'c + ab' + bc'd + a'bd'
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~a&c) | (a&~b) | (b&~c&d) | (~a&b&~d);
endmodule
