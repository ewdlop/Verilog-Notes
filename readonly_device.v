module readonly_device #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter DEVICE_DEPTH = 256
)(
    input wire clk,
    input wire rst_n,
    input wire read_enable,
    input wire [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg data_valid,
    output reg busy,
    // Status signals
    output reg error,
    output reg [2:0] status
);

    // Internal memory array
    reg [DATA_WIDTH-1:0] device_data [0:DEVICE_DEPTH-1];
    
    // Device states
    typedef enum {
        IDLE,
        READING,
        PROCESSING,
        ERROR_STATE
    } state_t;
    
    state_t current_state;
    reg [7:0] process_counter;
    
    // Status codes
    localparam STATUS_IDLE = 3'b000;
    localparam STATUS_BUSY = 3'b001;
    localparam STATUS_DONE = 3'b010;
    localparam STATUS_ERROR = 3'b111;

    // Initialize with some data (simulation only)
    initial begin
        integer i;
        for (i = 0; i < DEVICE_DEPTH; i = i + 1) begin
            device_data[i] = {16'hCAFE, i[15:0]};  // Example pattern
        end
    end

    // Main state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_out <= {DATA_WIDTH{1'b0}};
            data_valid <= 1'b0;
            busy <= 1'b0;
            error <= 1'b0;
            status <= STATUS_IDLE;
            process_counter <= 8'd0;
        end
        else begin
            case (current_state)
                IDLE: begin
                    if (read_enable) begin
                        if (addr < DEVICE_DEPTH) begin
                            current_state <= READING;
                            busy <= 1'b1;
                            status <= STATUS_BUSY;
                            process_counter <= 8'd5; // 5 cycle read delay
                        end
                        else begin
                            current_state <= ERROR_STATE;
                            error <= 1'b1;
                            status <= STATUS_ERROR;
                        end
                    end
                end

                READING: begin
                    if (process_counter == 0) begin
                        data_out <= device_data[addr];
                        current_state <= PROCESSING;
                        process_counter <= 8'd3; // 3 cycle processing time
                    end
                    else begin
                        process_counter <= process_counter - 1;
                    end
                end

                PROCESSING: begin
                    if (process_counter == 0) begin
                        data_valid <= 1'b1;
                        busy <= 1'b0;
                        status <= STATUS_DONE;
                        current_state <= IDLE;
                    end
                    else begin
                        process_counter <= process_counter - 1;
                    end
                end

                ERROR_STATE: begin
                    data_out <= {DATA_WIDTH{1'b0}};
                    data_valid <= 1'b0;
                    busy <= 1'b0;
                    current_state <= IDLE;
                end

                default: current_state <= IDLE;
            endcase
        end
    end

    // Clear signals when read_enable goes low
    always @(negedge read_enable) begin
        data_valid <= 1'b0;
        error <= 1'b0;
        if (current_state == IDLE) begin
            status <= STATUS_IDLE;
        end
    end

endmodule

// Testbench
module readonly_device_tb;
    reg clk;
    reg rst_n;
    reg read_enable;
    reg [7:0] addr;
    wire [31:0] data_out;
    wire data_valid;
    wire busy;
    wire error;
    wire [2:0] status;

    // Instantiate device
    readonly_device #(
        .ADDR_WIDTH(8),
        .DATA_WIDTH(32),
        .DEVICE_DEPTH(256)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .read_enable(read_enable),
        .addr(addr),
        .data_out(data_out),
        .data_valid(data_valid),
        .busy(busy),
        .error(error),
        .status(status)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Reset
        rst_n = 0;
        read_enable = 0;
        addr = 0;
        #20;
        rst_n = 1;

        // Valid read test
        #20;
        addr = 8'h10;
        read_enable = 1;
        wait(data_valid);
        #20;
        read_enable = 0;

        // Invalid address test
        #20;
        addr = 8'hFF;  // Beyond DEVICE_DEPTH
        read_enable = 1;
        #20;
        read_enable = 0;

        // Multiple reads
        repeat(5) begin
            #20;
            addr = $random % 256;
            read_enable = 1;
            wait(data_valid || error);
            #10;
            read_enable = 0;
        end

        // End simulation
        #100;
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t rst=%b re=%b addr=%h data=%h valid=%b busy=%b error=%b status=%b",
                 $time, rst_n, read_enable, addr, data_out, data_valid, busy, error, status);
    end

endmodule
