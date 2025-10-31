// NOR Flash Memory Controller
// Provides a simple interface to NOR flash memory with memory-mapped access
// Supports read, write, and erase operations

module nor_flash_controller #(
    parameter ADDR_WIDTH = 20,      // 1 MB addressable space
    parameter DATA_WIDTH = 16,      // 16-bit data bus
    parameter SECTOR_SIZE = 65536   // 64KB sector size
)(
    input wire clk,
    input wire rst_n,
    
    // Processor Interface
    input wire [ADDR_WIDTH-1:0] cpu_addr,
    input wire [DATA_WIDTH-1:0] cpu_data_in,
    output reg [DATA_WIDTH-1:0] cpu_data_out,
    input wire cpu_read,
    input wire cpu_write,
    input wire cpu_erase_sector,
    output reg cpu_ready,
    
    // NOR Flash Interface
    output reg [ADDR_WIDTH-1:0] flash_addr,
    inout wire [DATA_WIDTH-1:0] flash_data,
    output reg flash_ce_n,          // Chip enable (active low)
    output reg flash_oe_n,          // Output enable (active low)
    output reg flash_we_n,          // Write enable (active low)
    output reg flash_rst_n,         // Reset (active low)
    input wire flash_ready          // Ready/Busy from flash
);

    // State machine states
    localparam IDLE         = 3'b000;
    localparam READ         = 3'b001;
    localparam WRITE_CMD    = 3'b010;
    localparam WRITE_DATA   = 3'b011;
    localparam ERASE_CMD    = 3'b100;
    localparam WAIT_READY   = 3'b101;
    
    reg [2:0] state, next_state;
    reg [DATA_WIDTH-1:0] data_out_reg;
    reg data_dir;  // 0 = input from flash, 1 = output to flash
    
    // Command codes for NOR flash
    localparam CMD_READ       = 16'h00FF;
    localparam CMD_WRITE      = 16'h0040;
    localparam CMD_ERASE      = 16'h0020;
    localparam CMD_CONFIRM    = 16'h00D0;
    localparam CMD_STATUS     = 16'h0070;
    
    // Bidirectional data bus control
    assign flash_data = data_dir ? data_out_reg : {DATA_WIDTH{1'bz}};
    
    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    // Next state logic and control signals
    always @(*) begin
        // Default values
        next_state = state;
        flash_ce_n = 1'b1;
        flash_oe_n = 1'b1;
        flash_we_n = 1'b1;
        flash_rst_n = 1'b1;
        cpu_ready = 1'b0;
        data_dir = 1'b0;
        flash_addr = cpu_addr;
        data_out_reg = {DATA_WIDTH{1'b0}};
        
        case (state)
            IDLE: begin
                cpu_ready = 1'b1;
                flash_ce_n = 1'b0;
                
                if (cpu_read) begin
                    next_state = READ;
                end else if (cpu_write) begin
                    next_state = WRITE_CMD;
                end else if (cpu_erase_sector) begin
                    next_state = ERASE_CMD;
                end
            end
            
            READ: begin
                flash_ce_n = 1'b0;
                flash_oe_n = 1'b0;
                flash_we_n = 1'b1;
                cpu_data_out = flash_data;
                cpu_ready = 1'b1;
                next_state = IDLE;
            end
            
            WRITE_CMD: begin
                flash_ce_n = 1'b0;
                flash_we_n = 1'b0;
                data_dir = 1'b1;
                data_out_reg = CMD_WRITE;
                next_state = WRITE_DATA;
            end
            
            WRITE_DATA: begin
                flash_ce_n = 1'b0;
                flash_we_n = 1'b0;
                data_dir = 1'b1;
                data_out_reg = cpu_data_in;
                next_state = WAIT_READY;
            end
            
            ERASE_CMD: begin
                flash_ce_n = 1'b0;
                flash_we_n = 1'b0;
                data_dir = 1'b1;
                data_out_reg = CMD_ERASE;
                next_state = WAIT_READY;
            end
            
            WAIT_READY: begin
                flash_ce_n = 1'b0;
                if (flash_ready) begin
                    cpu_ready = 1'b1;
                    next_state = IDLE;
                end
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
