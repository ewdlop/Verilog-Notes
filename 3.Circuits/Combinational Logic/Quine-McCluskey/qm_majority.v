// Quine-McCluskey: Simple majority function (3 inputs)
// Output is 1 if at least 2 inputs are 1
// Minterms: 3,5,6,7
// Minimized form: ab + ac + bc
module top_module(
    input a,
    input b,
    input c,
    output out
);
    assign out = (a&b) | (a&c) | (b&c);
endmodule
