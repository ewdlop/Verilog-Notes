module rom_memory #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 256  // 2^8
)(
    input wire clk,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire enable,
    output reg [DATA_WIDTH-1:0] data_out
);

    // ROM storage
    reg [DATA_WIDTH-1:0] rom_array [0:DEPTH-1];

    // Initialize ROM with some data
    initial begin
        // Example initialization
        rom_array[0] = 32'hDEADBEEF;
        rom_array[1] = 32'h12345678;
        rom_array[2] = 32'hABCDEF01;
        // ... add more initializations as needed
    end

    // Read operation
    always @(posedge clk) begin
        if (enable) begin
            data_out <= rom_array[addr];
        end
        else begin
            data_out <= {DATA_WIDTH{1'bz}}; // High impedance when disabled
        end
    end

endmodule
