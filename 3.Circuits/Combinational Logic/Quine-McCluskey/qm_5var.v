// Quine-McCluskey minimization example with 5 variables
// Function: f(a,b,c,d,e) with minterms: 0,1,4,5,8,9,12,13,16,17,20,21
// Minimized form: a'c'e' + a'c'd' + ab'c'
// This demonstrates QM's advantage over K-maps for >4 variables
module top_module(
    input a,
    input b,
    input c,
    input d,
    input e,
    output out
);
    assign out = (~a&~c&~e) | (~a&~c&~d) | (a&~b&~c);
endmodule
