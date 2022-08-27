module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //

    wire [3:0] q0, q1, q2;
    
    bcdcount counter0 (clk, reset, c_enable[0],q0);
    bcdcount counter1 (clk, reset, c_enable[1],q1);
    bcdcount counter2 (clk, reset, c_enable[2],q2);
    
    assign c_enable = {(q1 == 4'd9) && (q0 == 4'd9), q0 == 4'd9, 1'b1};//increament every 100, 10, 1 cycle
    assign OneHertz = (q2 == 4'd9) && (q1 == 4'd9) && (q0 == 4'd9);//1000 cycle. or 1 second after(increase time of the wall clock by one second )

endmodule
