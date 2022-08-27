module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //
    
    //each byte is read-in in each cycle
    parameter byte1=2'd0, byte2=2'd1, byte3=2'd2, Done=2'd3;
    reg[1:0] state, next_state;
    // State transition logic (combinational)
    always@(*)begin
        case(state)
            byte1: next_state = in[3]? byte2:byte1;
            byte2: next_state = byte3;
            byte3: next_state = Done;
            Done : next_state = in[3]?byte2:byte1;
        endcase
    end
    // State flip-flops (sequential)
    always@(posedge clk)begin
        if(reset)state<=byte1;
     	else state<=next_state;
    end
    // Output logic
    assign done = (state == Done);
endmodule