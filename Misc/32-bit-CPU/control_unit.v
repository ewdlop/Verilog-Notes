module ControlUnit (
    input [5:0] opcode,
    output reg regWrite,
    output reg [2:0] ALUControl,
    output reg memToReg,
    output reg memWrite,
    output reg branch,
    output reg aluSrc,
    output reg regDst
);

    always @(*) begin
        case (opcode)
            6'b000000: begin // R-type
                regWrite = 1;
                ALUControl = 3'b010;
                memToReg = 0;
                memWrite = 0;
                branch = 0;
                aluSrc = 0;
                regDst = 1;
            end
            6'b100011: begin // LW
                regWrite = 1;
                ALUControl = 3'b000;
                memToReg = 1;
                memWrite = 0;
                branch = 0;
                aluSrc = 1;
                regDst = 0;
            end
            6'b101011: begin // SW
                regWrite = 0;
                ALUControl = 3'b000;
                memToReg = 0;
                memWrite = 1;
                branch = 0;
                aluSrc = 1;
            end
            6'b000100: begin // BEQ
                regWrite = 0;
                ALUControl = 3'b001;
                memToReg = 0;
                memWrite = 0;
                branch = 1;
                aluSrc = 0;
            end
            default: begin
                regWrite = 0;
                ALUControl = 3'b000;
                memToReg = 0;
                memWrite = 0;
                branch = 0;
                aluSrc = 0;
                regDst = 0;
            end
        endcase
    end
endmodule