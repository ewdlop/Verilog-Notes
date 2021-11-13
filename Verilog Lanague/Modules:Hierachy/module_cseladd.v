module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire cout;
    wire[15:0] sum1;
    wire[15:0] sum0;
    add16 adder1(a[15:0],b[15:0],0,sum[15:0],cout);
    add16 adder2(a[31:16],b[31:16],0,sum0);
    add16 adder3(a[31:16],b[31:16],1,sum1);
    always@(*)begin
        case(cout)
           	1'b0: sum[31:16] =sum0;
            1'b1: sum[31:16] =sum1;
        endcase
    end
    
endmodule
