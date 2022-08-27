module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    parameter A=3'd0,B=3'd1,C=3'd2,D=3'd3,E=3'd4,F=3'd5,G=3'd6, H=3'd7;
    reg[2:0] state,next_state;
    always@(*)begin
        case(state)
            A: next_state= s? B : A;
            B: next_state= w? C : D;
            C: next_state= w? E : F;
           	D: next_state= w? F : G;
            E: next_state= w? B : H;
            F: next_state= w? H : B;
            G: next_state= B;            
            H: next_state= w? C : D;
        endcase
    end
    always@(posedge clk)begin
        if(reset) state= A;
        else state <=next_state;
    end
    assign z = (state == H);

endmodule
