module write_only_device #(
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire rst_n,
    input wire write_enable,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg busy,
    output reg write_ack
);

    // Internal states
    typedef enum {
        IDLE,
        WRITING,
        PROCESSING
    } state_t;

    state_t current_state, next_state;
    reg [7:0] process_counter;
    reg [DATA_WIDTH-1:0] write_buffer;

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            process_counter <= 0;
            busy <= 0;
            write_ack <= 0;
            write_buffer <= 0;
        end
        else begin
            case (current_state)
                IDLE: begin
                    if (write_enable) begin
                        current_state <= WRITING;
                        write_buffer <= data_in;
                        busy <= 1;
                        write_ack <= 0;
                    end
                end

                WRITING: begin
                    current_state <= PROCESSING;
                    process_counter <= 8'd10; // Example: 10 cycle processing time
                end

                PROCESSING: begin
                    if (process_counter == 0) begin
                        current_state <= IDLE;
                        busy <= 0;
                        write_ack <= 1;
                    end
                    else begin
                        process_counter <= process_counter - 1;
                    end
                end

                default: current_state <= IDLE;
            endcase
        end
    end

    // Simulation display (remove in synthesis)
    always @(posedge clk) begin
        if (current_state == WRITING) begin
            $display("Writing data: %h", write_buffer);
        end
    end

endmodule

// Testbench
module write_only_device_tb;
    reg clk;
    reg rst_n;
    reg write_enable;
    reg [7:0] data_in;
    wire busy;
    wire write_ack;

    // Instantiate device
    write_only_device #(
        .DATA_WIDTH(8)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .write_enable(write_enable),
        .data_in(data_in),
        .busy(busy),
        .write_ack(write_ack)
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
        write_enable = 0;
        data_in = 0;
        #20;
        rst_n = 1;

        // Write test
        #20;
        data_in = 8'hAA;
        write_enable = 1;
        #10;
        write_enable = 0;

        // Wait for acknowledgment
        wait(write_ack);
        #20;

        // Another write
        data_in = 8'h55;
        write_enable = 1;
        #10;
        write_enable = 0;

        // End simulation
        #100;
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t rst_n=%b we=%b data=%h busy=%b ack=%b",
                 $time, rst_n, write_enable, data_in, busy, write_ack);
    end

endmodule
