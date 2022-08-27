module top_module (
    input clk,
    input [2:0] y,
    input x,
    output Y0,
    output z
);
    reg[2:0] Y;
    
    always@(*)begin
        case(y)
            3'b000: Y=~x?3'b000:3'b001;
            3'b001: Y=~x?3'b001:3'b100;
            3'b010: Y=~x?3'b010:3'b001;
            3'b011: Y=~x?3'b001:3'b010;
            3'b100: Y=~x?3'b011:3'b100;
            3'b101: Y=Y;
            3'b110: Y=Y;
            3'b111: Y=Y;
        endcase
    end
    
    assign Y0 = Y[0];
    assign z = (y==3'b011 ) | (y==3'b100);
endmodule
