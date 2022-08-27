module top_module (
    input clk,
    input reset,     // synchronous reset
    input w,
    output z);
    parameter a=3'b000, b=3'b001, c=3'b010, d=3'b011, e=3'b100, f=3'b101;
    reg[2:0] state,next_state;
    always@(*)begin
        case(state)
        	a:next_state=w?a:b;
            b:next_state=w?d:c;
            c:next_state=w?d:e;
            d:next_state=w?a:f;
            e:next_state=w?d:e;
            f:next_state=w?d:c;
        endcase
    end
    always@(posedge clk)begin
        if(reset)state<=a;
        else state<=next_state;
    end
    assign z=(state==e)|(state==f);
endmodule