module top_module (
    input clk,
    input j,
    input k,
    output Q); 
    
    wire[1:0] con;
    assign con = {j,k};
    always@(posedge clk) begin
        case(con)
            2'b00: Q<=Q;
            2'b10: Q<=1'b1;
            2'b01: Q<=1'b0;
            2'b11: Q<=~Q;
        endcase
    end
endmodule