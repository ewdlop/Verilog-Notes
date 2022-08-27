module top_module( 
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );
	
    wire[4:0] carry;
    assign carry[0]=cin;
    genvar i;
    generate 
        for(i=1'b1;i<=4;i=i+1'b1)
            begin : gen
                bcd_fadd add (
                    .a(a[(i*4-1)-:4]),
                    .b(b[(i*4-1)-:4]),
                    .cin(carry[i-1]),
                    .cout(carry[i]),
                    .sum(sum[(i*4-1)-:4]) ); 
               end 
     endgenerate
    assign cout=carry[4];
    
endmodule
