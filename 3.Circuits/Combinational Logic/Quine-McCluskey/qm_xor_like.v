// Quine-McCluskey: Complex function (4 inputs)
// Function: f(a,b,c,d) with minterms: 1,2,4,7,8,11,13,14
// Each minterm is listed individually (limited simplification possible)
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~a&~b&~c&d) | (~a&~b&c&~d) | (~a&b&~c&~d) | (~a&b&c&d)
               | (a&~b&~c&~d) | (a&~b&c&d) | (a&b&~c&d) | (a&b&c&~d);
endmodule
