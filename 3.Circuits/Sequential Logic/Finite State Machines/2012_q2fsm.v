module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    input w,
    output z
);
    parameter a=3'b000, b=3'b001, c=3'b010, d=3'b011, e=3'b100, f=3'b101;
    reg[2:0] state,next_state;
    always@(*)begin
        case(state)
        	a:next_state=w?b:a;
            b:next_state=w?c:d;
            c:next_state=w?e:d;
            d:next_state=w?f:a;
            e:next_state=w?e:d;
            f:next_state=w?c:d;
        endcase
    end
    always@(posedge clk)begin
        if(reset)state<=a;
        else state<=next_state;
    end
    assign z=(state==e)|(state==f);
endmodule
