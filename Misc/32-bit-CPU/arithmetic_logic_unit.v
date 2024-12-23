module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output Zero
);

    assign Zero = (ALUResult == 0);

    always @(*) begin
        case (ALUControl)
            3'b000: ALUResult = A + B; // ADD
            3'b001: ALUResult = A - B; // SUB
            3'b010: ALUResult = A & B; // AND
            3'b011: ALUResult = A | B; // OR
            3'b100: ALUResult = A ^ B; // XOR
            3'b101: ALUResult = (A < B) ? 1 : 0; // SLT
            default: ALUResult = 0;
        endcase
    end
endmodule