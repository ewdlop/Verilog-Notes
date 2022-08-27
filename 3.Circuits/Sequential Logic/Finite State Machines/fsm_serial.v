module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 

    parameter 
    IDLE  = 4'd0,
    START = 4'd1,
    BIT1  = 4'd2,
    BIT2  = 4'd3,
    BIT3  = 4'd4,
    BIT4  = 4'd5,
    BIT5  = 4'd6,
    BIT6  = 4'd7,
    BIT7  = 4'd8,
    BIT8  = 4'd9,
    STOP  = 4'd10,
   	ERROR  = 4'd11;
    reg [3:0] state,nstate;
    
    always @(posedge clk)begin
        if(reset)begin
            state <= IDLE;
        end
        else begin
           state <= nstate; 
        end
    end
    
    always @(*)begin
       nstate = IDLE;
        case(state)
            IDLE: nstate = in? IDLE:START;
            START:nstate = BIT1;
            BIT1: nstate = BIT2;
            BIT2: nstate = BIT3;
            BIT3: nstate = BIT4;
            BIT4: nstate = BIT5;
            BIT5: nstate = BIT6;
            BIT6: nstate = BIT7;
            BIT7: nstate = BIT8;
            BIT8: nstate = in? STOP:ERROR;
            STOP: nstate = in? IDLE:START;
            ERROR: nstate = in? IDLE:ERROR;
            default: nstate = IDLE;
        endcase
    end
    
    assign done = (state == STOP);

    
endmodule
