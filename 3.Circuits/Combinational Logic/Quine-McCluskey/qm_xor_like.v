// Quine-McCluskey: XOR-like function (4 inputs)
// Function: f(a,b,c,d) with minterms: 1,2,4,7,8,11,13,14
// Minimized form: a'b'cd' + a'bc'd' + ab'c'd + abc'd'
// + a'b'c'd + ab'cd + abc'd + a'bcd
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~a&~b&c&~d) | (~a&b&~c&~d) | (a&~b&~c&d) | (a&b&~c&~d)
               | (~a&~b&~c&d) | (a&~b&c&d) | (a&b&~c&d) | (~a&b&c&d);
endmodule
