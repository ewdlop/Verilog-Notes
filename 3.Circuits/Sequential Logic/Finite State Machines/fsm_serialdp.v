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
    DONE = 4'd11,
   	ERROR  = 4'd12,
    FAL = 4'd13;
    
    reg [3:0] state,nstate;
    reg [7:0] bitstream;
	reg odd;
    
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
            BIT8: nstate = STOP;
            STOP: begin 
                if(in & odd) nstate = DONE;
                else if (in & ~odd) nstate = FAL;
                else nstate = ERROR;
            end
            DONE: nstate = in ? IDLE:START;
            ERROR: nstate = in? IDLE:ERROR;
            FAL:  nstate = in? IDLE:START;
            default: nstate = IDLE;
        endcase
    end
    
    always @(posedge clk)begin
        if(reset)state <= IDLE;
        else begin
           state <= nstate;
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
    end
    
    wire in_check;
    assign in_check = in&((state == START)|(state == BIT1) | (state == BIT2) | (state == BIT3) | (state == BIT4) | (state == BIT5) | (state == BIT6) | (state == BIT7) | (state == BIT8));
    parity parity_checker(clk,(reset | (state == IDLE) | (state == DONE)),in_check,odd);
    
    assign done = (state == DONE);
    assign out_byte = (state == DONE)? bitstream:8'bx;

endmodule