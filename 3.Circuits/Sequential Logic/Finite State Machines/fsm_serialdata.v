module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

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
    reg [7:0] bitstream;

    always @(*)begin
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
    
    always @(posedge clk)begin
        if(reset)begin
            state <= IDLE;
        end
        else begin
           state <= nstate; 
        end
        case(nstate)//serial protocol sends the least significant bit first.
            BIT1: bitstream <= {in,bitstream[7:1]};
            BIT2: bitstream <= {in,bitstream[7:1]};
            BIT3: bitstream <= {in,bitstream[7:1]};
            BIT4: bitstream <= {in,bitstream[7:1]};
            BIT5: bitstream <= {in,bitstream[7:1]};
            BIT6: bitstream <= {in,bitstream[7:1]};
            BIT7: bitstream <= {in,bitstream[7:1]};
            BIT8: bitstream <= {in,bitstream[7:1]}; 
        endcase
    end
    
    assign done = (state == STOP);
    assign out_byte = (state == STOP)? bitstream:8'bx;

endmodule
