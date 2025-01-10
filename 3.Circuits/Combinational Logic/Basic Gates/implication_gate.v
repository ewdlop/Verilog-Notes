module implication_gate (
    input wire A,  // Input A
    input wire B,  // Input B
    output wire R  // Output R (A -> B)
);

    // Logical implication: R = ~A | B
    assign R = ~A | B;

endmodule
