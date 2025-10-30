// NAND Flash Memory Controller
// Provides page-based interface to NAND flash memory
// Supports page read, page program, and block erase operations

module nand_flash_controller #(
    parameter ADDR_WIDTH = 24,          // Address width for page addressing
    parameter DATA_WIDTH = 8,           // I/O data width (typically 8-bit)
    parameter PAGE_SIZE = 2048,         // Page size in bytes
    parameter PAGES_PER_BLOCK = 64,     // Typical pages per block
    parameter SPARE_SIZE = 64           // Spare/OOB area size
)(
    input wire clk,
    input wire rst_n,
    
    // Host Interface
    input wire [ADDR_WIDTH-1:0] host_page_addr,
    input wire [15:0] host_byte_addr,
    input wire [DATA_WIDTH-1:0] host_data_in,
    output reg [DATA_WIDTH-1:0] host_data_out,
    input wire host_read_page,
    input wire host_write_page,
    input wire host_erase_block,
    input wire host_read_id,
    output reg host_ready,
    output reg host_error,
    
    // NAND Flash Interface (8-bit I/O)
    inout wire [7:0] flash_io,
    output reg flash_cle,               // Command latch enable
    output reg flash_ale,               // Address latch enable
    output reg flash_ce_n,              // Chip enable (active low)
    output reg flash_we_n,              // Write enable (active low)
    output reg flash_re_n,              // Read enable (active low)
    input wire flash_rb_n,              // Ready/Busy (active low)
    output reg flash_wp_n               // Write protect (active low)
);

    // NAND Flash Commands
    localparam CMD_READ_1ST       = 8'h00;
    localparam CMD_READ_2ND       = 8'h30;
    localparam CMD_READ_ID        = 8'h90;
    localparam CMD_RESET          = 8'hFF;
    localparam CMD_PAGE_PROGRAM_1 = 8'h80;
    localparam CMD_PAGE_PROGRAM_2 = 8'h10;
    localparam CMD_BLOCK_ERASE_1  = 8'h60;
    localparam CMD_BLOCK_ERASE_2  = 8'hD0;
    localparam CMD_READ_STATUS    = 8'h70;
    
    // State machine states
    localparam IDLE              = 4'd0;
    localparam READ_CMD1         = 4'd1;
    localparam READ_ADDR         = 4'd2;
    localparam READ_CMD2         = 4'd3;
    localparam READ_WAIT         = 4'd4;
    localparam READ_DATA         = 4'd5;
    localparam WRITE_CMD1        = 4'd6;
    localparam WRITE_ADDR        = 4'd7;
    localparam WRITE_DATA        = 4'd8;
    localparam WRITE_CMD2        = 4'd9;
    localparam ERASE_CMD1        = 4'd10;
    localparam ERASE_ADDR        = 4'd11;
    localparam ERASE_CMD2        = 4'd12;
    localparam WAIT_READY        = 4'd13;
    localparam READ_STATUS_STATE = 4'd14;
    
    reg [3:0] state, next_state;
    reg [7:0] io_out;
    reg io_dir;  // 0 = input from flash, 1 = output to flash
    reg [3:0] addr_cycle;
    reg [15:0] byte_counter;
    reg [7:0] status_reg;
    
    // Bidirectional I/O control
    assign flash_io = io_dir ? io_out : 8'hzz;
    
    // Page buffer (simplified - in real implementation would be larger)
    reg [DATA_WIDTH-1:0] page_buffer [0:PAGE_SIZE-1];
    
    // State machine - sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            addr_cycle <= 4'd0;
            byte_counter <= 16'd0;
        end else begin
            state <= next_state;
            
            // Address cycle counter
            if (state == READ_ADDR || state == WRITE_ADDR || state == ERASE_ADDR) begin
                addr_cycle <= addr_cycle + 1'b1;
            end else begin
                addr_cycle <= 4'd0;
            end
            
            // Byte counter for data transfer
            if (state == READ_DATA || state == WRITE_DATA) begin
                byte_counter <= byte_counter + 1'b1;
            end else begin
                byte_counter <= 16'd0;
            end
        end
    end
    
    // State machine - combinational logic
    always @(*) begin
        // Default values
        next_state = state;
        flash_cle = 1'b0;
        flash_ale = 1'b0;
        flash_ce_n = 1'b1;
        flash_we_n = 1'b1;
        flash_re_n = 1'b1;
        flash_wp_n = 1'b1;  // Write protect off
        io_dir = 1'b0;
        io_out = 8'h00;
        host_ready = 1'b0;
        host_error = 1'b0;
        host_data_out = 8'h00;
        
        case (state)
            IDLE: begin
                host_ready = 1'b1;
                flash_ce_n = 1'b0;
                
                if (host_read_page) begin
                    next_state = READ_CMD1;
                end else if (host_write_page) begin
                    next_state = WRITE_CMD1;
                end else if (host_erase_block) begin
                    next_state = ERASE_CMD1;
                end
            end
            
            // === Page Read Sequence ===
            READ_CMD1: begin
                flash_ce_n = 1'b0;
                flash_cle = 1'b1;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                io_out = CMD_READ_1ST;
                next_state = READ_ADDR;
            end
            
            READ_ADDR: begin
                flash_ce_n = 1'b0;
                flash_ale = 1'b1;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                
                // Send 5 address cycles (column addr + row addr)
                case (addr_cycle)
                    4'd0: io_out = host_byte_addr[7:0];         // Column address byte 1
                    4'd1: io_out = host_byte_addr[15:8];        // Column address byte 2
                    4'd2: io_out = host_page_addr[7:0];         // Row address byte 1
                    4'd3: io_out = host_page_addr[15:8];        // Row address byte 2
                    4'd4: begin
                        io_out = host_page_addr[23:16];        // Row address byte 3
                        next_state = READ_CMD2;
                    end
                    default: io_out = 8'h00;
                endcase
            end
            
            READ_CMD2: begin
                flash_ce_n = 1'b0;
                flash_cle = 1'b1;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                io_out = CMD_READ_2ND;
                next_state = READ_WAIT;
            end
            
            READ_WAIT: begin
                flash_ce_n = 1'b0;
                // Wait for R/B# to go high (operation complete)
                if (flash_rb_n == 1'b1) begin
                    next_state = READ_DATA;
                end
            end
            
            READ_DATA: begin
                flash_ce_n = 1'b0;
                flash_re_n = 1'b0;
                host_data_out = flash_io;
                
                if (byte_counter >= PAGE_SIZE - 1) begin
                    next_state = IDLE;
                end
            end
            
            // === Page Program Sequence ===
            WRITE_CMD1: begin
                flash_ce_n = 1'b0;
                flash_cle = 1'b1;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                io_out = CMD_PAGE_PROGRAM_1;
                next_state = WRITE_ADDR;
            end
            
            WRITE_ADDR: begin
                flash_ce_n = 1'b0;
                flash_ale = 1'b1;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                
                case (addr_cycle)
                    4'd0: io_out = host_byte_addr[7:0];
                    4'd1: io_out = host_byte_addr[15:8];
                    4'd2: io_out = host_page_addr[7:0];
                    4'd3: io_out = host_page_addr[15:8];
                    4'd4: begin
                        io_out = host_page_addr[23:16];
                        next_state = WRITE_DATA;
                    end
                    default: io_out = 8'h00;
                endcase
            end
            
            WRITE_DATA: begin
                flash_ce_n = 1'b0;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                io_out = host_data_in;
                
                if (byte_counter >= PAGE_SIZE - 1) begin
                    next_state = WRITE_CMD2;
                end
            end
            
            WRITE_CMD2: begin
                flash_ce_n = 1'b0;
                flash_cle = 1'b1;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                io_out = CMD_PAGE_PROGRAM_2;
                next_state = WAIT_READY;
            end
            
            // === Block Erase Sequence ===
            ERASE_CMD1: begin
                flash_ce_n = 1'b0;
                flash_cle = 1'b1;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                io_out = CMD_BLOCK_ERASE_1;
                next_state = ERASE_ADDR;
            end
            
            ERASE_ADDR: begin
                flash_ce_n = 1'b0;
                flash_ale = 1'b1;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                
                // Send 3 row address cycles for block erase
                case (addr_cycle)
                    4'd0: io_out = host_page_addr[7:0];
                    4'd1: io_out = host_page_addr[15:8];
                    4'd2: begin
                        io_out = host_page_addr[23:16];
                        next_state = ERASE_CMD2;
                    end
                    default: io_out = 8'h00;
                endcase
            end
            
            ERASE_CMD2: begin
                flash_ce_n = 1'b0;
                flash_cle = 1'b1;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                io_out = CMD_BLOCK_ERASE_2;
                next_state = WAIT_READY;
            end
            
            // === Wait for operation completion ===
            WAIT_READY: begin
                flash_ce_n = 1'b0;
                if (flash_rb_n == 1'b1) begin
                    next_state = READ_STATUS_STATE;
                end
            end
            
            READ_STATUS_STATE: begin
                flash_ce_n = 1'b0;
                flash_cle = 1'b1;
                flash_we_n = 1'b0;
                io_dir = 1'b1;
                io_out = CMD_READ_STATUS;
                
                // Read status register
                flash_re_n = 1'b0;
                status_reg = flash_io;
                
                // Check for errors (bit 0 indicates pass/fail)
                if (status_reg[0] == 1'b1) begin
                    host_error = 1'b1;
                end
                
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
