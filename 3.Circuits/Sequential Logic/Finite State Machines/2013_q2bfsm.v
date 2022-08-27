module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
    parameter
	A = 4'd0,
    Af= 4'd1,
    B0= 4'd2,
    B1= 4'd3,
    B2= 4'd4,
    B3= 4'd5,
    G1= 4'd6,
    G0_1= 4'd7,
    G0_2= 4'd8;
    
    reg [3:0] state,next_state;
    always@(posedge clk) begin
        if(!resetn) state <= A;
        else state <= next_state;
    end
    always@(*) begin
        case(state)
            A: next_state = Af; // output f to 1 in the very next cycle
            Af:next_state = B0; // output f to 1 for one clock cycle
            B0:next_state = x? B1: B0;
            B1:next_state = x? B1: B2;
            B2:next_state = x? B3: B0;
            B3:next_state = y? G1: G0_1;
            G1:next_state = G1; //maintain for g=1
            G0_1:next_state = y? G1: G0_2;
            G0_2:next_state = G0_2; //maintain for g=2
            default next_state = A;
        endcase
    end
    
    assign g = (state==B3)||(state==G1)||(state==G0_1); //includes G0_1 becausee g should be set to 1 after the 101 cycle
    assign f = (state==Af);
    
endmodule
