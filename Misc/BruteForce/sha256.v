module sha256_core (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [511:0] message,
    output reg [255:0] hash,
    output reg ready
);
    // Constants for SHA-256
    localparam [31:0] K [0:63] = {
        32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5,
        // (remaining 60 constants)
    };

    // Initial hash values
    reg [31:0] H [0:7] = {
        32'h6a09e667, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a,
        32'h510e527f, 32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19
    };

    // Internal registers
    reg [31:0] W [0:63];
    reg [31:0] a, b, c, d, e, f, g, h;
    reg [31:0] temp1, temp2;
    integer t;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ready <= 0;
            hash <= 0;
        end else if (start) begin
            // Initialize working variables
            a <= H[0];
            b <= H[1];
            c <= H[2];
            d <= H[3];
            e <= H[4];
            f <= H[5];
            g <= H[6];
            h <= H[7];

            // Prepare message schedule
            for (t = 0; t < 16; t = t + 1) W[t] <= message[511 - 32*t -: 32];
            for (t = 16; t < 64; t = t + 1) W[t] <= W[t-16] + W[t-7] + (W[t-15] >> 7) + (W[t-2] >> 17);

            // Main loop
            for (t = 0; t < 64; t = t + 1) begin
                temp1 <= h + ((e >> 6) | (e << 26)) + ((e & f) ^ (~e & g)) + K[t] + W[t];
                temp2 <= ((a >> 2) | (a << 30)) + ((a & b) ^ (a & c) ^ (b & c));
                h <= g;
                g <= f;
                f <= e;
                e <= d + temp1;
                d <= c;
                c <= b;
                b <= a;
                a <= temp1 + temp2;
            end

            // Compute final hash value
            H[0] <= H[0] + a;
            H[1] <= H[1] + b;
            H[2] <= H[2] + c;
            H[3] <= H[3] + d;
            H[4] <= H[4] + e;
            H[5] <= H[5] + f;
            H[6] <= H[6] + g;
            H[7] <= H[7] + h;

            // Output hash
            hash <= {H[0], H[1], H[2], H[3], H[4], H[5], H[6], H[7]};
            ready <= 1;
        end else begin
            ready <= 0;
        end
    end
endmodule
