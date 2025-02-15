module bcd_digital_clock(
    input clk,          // 1Hz clock input
    input reset,        // Active-high reset
    output [3:0] hh_tens, hh_ones,  // Hour digits (BCD)
    output [3:0] mm_tens, mm_ones,  // Minute digits (BCD)
    output [3:0] ss_tens, ss_ones   // Second digits (BCD)
);

// Internal counters
reg [5:0] seconds;     // 0-59
reg [5:0] minutes;     // 0-59
reg [4:0] hours;       // 0-23

// Seconds counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        seconds <= 0;
    end else begin
        seconds <= (seconds == 6'd59) ? 6'd0 : seconds + 1;
    end
end

// Minutes counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        minutes <= 0;
    end else if (seconds == 6'd59) begin
        minutes <= (minutes == 6'd59) ? 6'd0 : minutes + 1;
    end
end

// Hours counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        hours <= 0;
    end else if (seconds == 6'd59 && minutes == 6'd59) begin
        hours <= (hours == 5'd23) ? 5'd0 : hours + 1;
    end
end

// BCD conversion for seconds
assign ss_tens = (seconds >= 50) ? 4'd5 :
                (seconds >= 40) ? 4'd4 :
                (seconds >= 30) ? 4'd3 :
                (seconds >= 20) ? 4'd2 :
                (seconds >= 10) ? 4'd1 : 4'd0;
                
assign ss_ones = seconds - ss_tens * 10;

// BCD conversion for minutes
assign mm_tens = (minutes >= 50) ? 4'd5 :
                (minutes >= 40) ? 4'd4 :
                (minutes >= 30) ? 4'd3 :
                (minutes >= 20) ? 4'd2 :
                (minutes >= 10) ? 4'd1 : 4'd0;
                
assign mm_ones = minutes - mm_tens * 10;

// BCD conversion for hours
assign hh_tens = (hours >= 20) ? 4'd2 :
                (hours >= 10) ? 4'd1 : 4'd0;
                
assign hh_ones = hours - hh_tens * 10;

endmodule
