module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=1'b0, ON=1'b1; 
    reg state, next_state;

    always_comb begin    // This is a combinational always block
        // State transition logic
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON: next_state = k ? OFF : ON;
        endcase
    end

    always @(posedge clk, posedge areset) begin    // This is a sequential always block
        // State flip-flops with asynchronous reset
        if(areset) state <= OFF;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == ON);

endmodule
