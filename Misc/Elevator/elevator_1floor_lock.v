module elevator_1floor_lock(
    input clk,
    input reset,
    input button,    // Button to move to floor 1
    input hold,      // Button to hold the elevator at the current floor
    input lock,      // Lock button to lock the elevator
    output reg floor_1
);

    reg current_state, next_state;

    // State definition
    parameter IDLE = 1'b0, MOVING = 1'b1, LOCKED = 2'b10;

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
                if (button && !lock) begin
                    next_state = MOVING;
                    floor_1 = 1'b1;
                end else if (lock) begin
                    next_state = LOCKED;
                    floor_1 = 1'b0;
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
            LOCKED: begin
                floor_1 = 1'b0;  // No movement when locked
                next_state = LOCKED;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
