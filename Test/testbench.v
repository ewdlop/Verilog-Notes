module testbench;

    reg A, B;          // Inputs
    wire R;            // Output

    // Instantiate the implication gate module
    implication_gate uut (
        .A(A),
        .B(B),
        .R(R)
    );

    initial begin
        // Test all combinations of A and B
        $display("A B | R");
        $monitor("%b %b | %b", A, B, R);

        A = 0; B = 0; #10;  // Expect R = 1
        A = 0; B = 1; #10;  // Expect R = 1
        A = 1; B = 0; #10;  // Expect R = 0
        A = 1; B = 1; #10;  // Expect R = 1

        $finish;
    end
endmodule
