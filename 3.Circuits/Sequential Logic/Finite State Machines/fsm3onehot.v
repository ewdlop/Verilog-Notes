module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;

    always@(*)begin
    // State transition logic: Derive an equation for each state flip-flop.
        next_state[A] = state[0]&(~in)| state[2]&(~in);
        next_state[B] = state[0]&(in) | state[1]&(in) | state[3]&(in);
        next_state[C] = state[1]&(~in) | state[3]&(~in);
        next_state[D] = state[2]&(in);
    end
    // Output logic: 
    assign out = (state[3] == 1);

endmodule