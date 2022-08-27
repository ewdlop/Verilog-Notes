module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
);
    reg[3:0] Q_check;
    assign c_enable = enable; //continous driven;
    always@(posedge clk)begin

        if(reset)begin
            Q <= 4'b1;
            Q_check <= 4'b1;
        end
        else begin
            if(enable) begin
                if(Q ==4'd12) begin
                    Q<=4'd1;
                    Q_check<=4'd1;
                end
                else begin
                    Q<=Q+4'd1;
                    Q_check<=Q_check+4'd1;
                end
            end
        end
    end
    
    always @(*) begin
        if(reset || (Q ==4'd12&& c_enable)) begin
            c_load = 1;
            c_d = 4'd1;
        end
        else begin
            c_load = 0;
            c_d = 4'd0;
        end
    end
    
    count4 counter(clk, c_enable, c_load, c_d, Q_check);

endmodule
