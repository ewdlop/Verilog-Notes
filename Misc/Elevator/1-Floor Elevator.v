module elevator_1floor(
    input clk,
    input reset,
    input button,    // Button to move to floor 1
    input hold,      // Button to hold the elevator at the current floor
    output reg floor_1
);

    reg current_state, next_state;

    // State definition
    parameter IDLE = 1'b0, MOVING = 1'b1;

    // State machine logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            floor_1 <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (button) begin
                    next_state = MOVING;
                    floor_1 = 1'b1;
                end else begin
                    next_state = IDLE;
                    floor_1 = 1'b0;
                end
            end
            MOVING: begin
                if (hold) begin
                    next_state = IDLE;  // Hold elevator at current floor
                    floor_1 = 1'b1;
                end else begin
                    next_state = MOVING;
                    floor_1 = 1'b1;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
