module top_module(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2);
	
    always@(*)begin
        next_state[9] = state[6]&&~in;
        next_state[8] = state[5]&&~in;
        next_state[7] = (state[6]&&in) | (state[7]&&in);
        next_state[6] = state[5]&&in;
        next_state[5] = state[4]&&in;
        next_state[4] = state[3]&&in;
        next_state[3] = state[2]&&in;
        next_state[2] = state[1]&&in;
        next_state[1] = (state[0]&&in) | (state[8]&&in) | (state[9]&&in);
        next_state[0] = ~in&(state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]);
    end
    
    assign out1 = (state[8]==1)|(state[9]==1);
    assign out2 = (state[7]==1)|(state[9]==1);
endmodule
