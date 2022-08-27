module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
	
    parameter start = 0, mid = 1, ends = 2;
    reg [1:0] state, next_state;
    always @(*) begin
        case (state)
            start: next_state = x ? mid : start;
            mid: next_state = x ? mid : ends;
            ends: next_state = x ? mid : start;
            default: next_state = 'x;
        endcase
    end
    
    always@(posedge clk or negedge aresetn)begin
    	if (!aresetn) state <= start;
        else state <= next_state;
    end
    
    always @(*) begin
        case (state)
            start: z = 0;
            mid: z = 0;
            ends: z = x;
            default: z = 1'bx;
        endcase
    end
    
endmodule