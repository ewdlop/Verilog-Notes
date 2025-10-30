// Optical OR Gate Implementation
//
// This module simulates an optical OR gate using Verilog.
// In optical computing, an OR gate can be implemented using:
// - Beam combiners or optical couplers
// - Two input laser beams with binary encoding (0=no light, 1=light present)
// - The output has light when either or both inputs have light (logical OR)
//
// Physical Implementation:
// - Input A and B are represented as optical signals (light intensity)
// - The gate uses passive optical coupling or beam splitting
// - Output light is produced when at least one input is present
// - Can be implemented with Y-branch waveguides or directional couplers

module optical_or_gate (
    input wire A,  // Optical Input A (0=no light, 1=light)
    input wire B,  // Optical Input B (0=no light, 1=light)
    output wire Y  // Optical Output Y (0=no light, 1=light)
);

    // Logical OR operation: Y = A OR B
    // In optical implementation:
    // - Either beam present generates output
    // - Uses beam combiner or optical coupler
    assign Y = A | B;

endmodule
