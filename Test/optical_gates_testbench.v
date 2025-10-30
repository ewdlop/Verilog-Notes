// Testbench for Optical Logic Gates
//
// This testbench verifies the functionality of optical AND and OR gates

`timescale 1ns / 1ps

module optical_gates_testbench;

    // Inputs
    reg A;
    reg B;

    // Outputs
    wire Y_and;
    wire Y_or;

    // Instantiate the optical AND gate
    optical_and_gate uut_and (
        .A(A),
        .B(B),
        .Y(Y_and)
    );

    // Instantiate the optical OR gate
    optical_or_gate uut_or (
        .A(A),
        .B(B),
        .Y(Y_or)
    );

    initial begin
        // Display header
        $display("=========================================");
        $display("Optical Logic Gates Test");
        $display("=========================================");
        $display("Time\tA\tB\t|\tAND\tOR");
        $display("-----------------------------------------");

        // Monitor signals
        $monitor("%0t\t%b\t%b\t|\t%b\t%b", $time, A, B, Y_and, Y_or);

        // Test all input combinations
        A = 0; B = 0; #10;  // Both off
        A = 0; B = 1; #10;  // Only B on
        A = 1; B = 0; #10;  // Only A on
        A = 1; B = 1; #10;  // Both on

        $display("=========================================");
        $display("Test completed successfully!");
        $display("=========================================");
        
        $finish;
    end

endmodule
