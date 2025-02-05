module elevator_2floor_lock(
    input clk,
    input reset,
    input button_1,  // Button to move to floor 1
    input button_2,  // Button to move to floor 2
    input hold,      // Button to hold the elevator at the current floor
    input lock,      // Lock button to lock the elevator
    output reg floor_1, floor_2
);

    reg current_state, next_state;

    // State definition
    parameter IDLE = 2'b00, MOVING_1 = 2'b01, MOVING_2 = 2'b10, LOCKED = 2'b11;

    // State machine logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            floor_1 <= 1'b0;
            floor_2 <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (button_1 && !lock) begin
                    next_state = MOVING_1;
                    floor_1 = 1'b1;
                    floor_2 = 1'b0;
                end else if (button_2 && !lock) begin
                    next_state = MOVING_2;
                    floor_1 = 1'b0;
                    floor_2 = 1'b1;
                end else if (lock) begin
                    next_state = LOCKED;
                    floor_1 = 1'b0;
                    floor_2 = 1'b0;
                end else begin
                    next_state = IDLE;
                    floor_1 = 1'b0;
                    floor_2 = 1'b0;
                end
            end
            MOVING_1: begin
                if (hold) begin
                    next_state = IDLE;
                    floor_1 = 1'b1;
                    floor_2 = 1'b0;
                end else begin
                    next_state = MOVING_1;
                    floor_1 = 1'b1;
                    floor_2 = 1'b0;
                end
            end
            MOVING_2: begin
                if (hold) begin
                    next_state = IDLE;
                    floor_1 = 1'b0;
                    floor_2 = 1'b1;
                end else begin
                    next_state = MOVING_2;
                    floor_1 = 1'b0;
                    floor_2 = 1'b1;
                end
            end
            LOCKED: begin
                floor_1 = 1'b0;
                floor_2 = 1'b0;
                next_state = LOCKED;
            end
            default: begin
                next_state = IDLE;
                floor_1 = 1'b0;
                floor_2 = 1'b0;
            end
        endcase
    end

endmodule
