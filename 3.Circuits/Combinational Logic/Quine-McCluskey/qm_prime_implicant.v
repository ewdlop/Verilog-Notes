// Quine-McCluskey: Prime implicant example
// Function: f(a,b,c,d) with minterms: 0,2,5,6,7,8,10,12,13,14,15
// Minimized form: ab + ac + b'c' + a'd
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (a&b) | (a&c) | (~b&~c) | (~a&d);
endmodule
