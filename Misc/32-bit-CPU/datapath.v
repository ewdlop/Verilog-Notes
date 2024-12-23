module CPU (
    input clk,
    input reset
);

    // Program Counter (PC)
    reg [31:0] pc;
    wire [31:0] next_pc, pc_plus_4, branch_target;

    // Instruction Memory
    reg [31:0] instruction_memory [0:255];
    wire [31:0] instruction;

    // Control Signals
    wire regWrite, memToReg, memWrite, aluSrc, regDst, branch, zero;
    wire [2:0] ALUControl;

    // Register File
    wire [4:0] readReg1, readReg2, writeReg;
    wire [31:0] readData1, readData2, writeDataReg;

    // ALU
    wire [31:0] ALUResult, ALUInput2, signImm;

    // Data Memory
    reg [31:0] data_memory [0:255];
    wire [31:0] readData;

    // Fetch the instruction based on the current PC
    assign instruction = instruction_memory[pc[9:2]];

    // Increment PC by 4
    assign pc_plus_4 = pc + 4;

    // Control Unit
    ControlUnit cu (
        .opcode(instruction[31:26]),
        .regWrite(regWrite),
        .ALUControl(ALUControl),
        .memToReg(memToReg),
        .memWrite(memWrite),
        .branch(branch),
        .aluSrc(aluSrc),
        .regDst(regDst)
    );

    // Register File
    RegisterFile rf (
        .clk(clk),
        .regWrite(regWrite),
        .readReg1(instruction[25:21]),
        .readReg2(instruction[20:16]),
        .writeReg(regDst ? instruction[15:11] : instruction[20:16]),
        .writeData(writeDataReg),
        .readData1(readData1),
        .readData2(readData2)
    );

    // Sign Extend the immediate value
    assign signImm = {{16{instruction[15]}}, instruction[15:0]};

    // ALU Input 2 Mux
    assign ALUInput2 = aluSrc ? signImm : readData2;

    // ALU
    ALU alu (
        .A(readData1),
        .B(ALUInput2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(zero)
    );

    // Data Memory
    assign readData = data_memory[ALUResult[9:2]];
    always @(posedge clk) begin
        if (memWrite) begin
            data_memory[ALUResult[9:2]] <= readData2;
        end
    end

    // Write Data Mux
    assign writeDataReg = memToReg ? readData : ALUResult;

    // Branch Target Calculation
    assign branch_target = pc_plus_4 + (signImm << 2);

    // Next PC Calculation
    assign next_pc = branch && zero ? branch_target : pc_plus_4;

    // Program Counter Update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
        end else begin
            pc <= next_pc;
        end
    end

endmodule