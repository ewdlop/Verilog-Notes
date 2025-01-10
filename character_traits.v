module character_traits (
    input wire enjoys_puzzles,
    input wire likes_helping_others,
    input wire adventurous,
    input wire prefers_working_alone,
    input wire enjoys_art,
    input wire likes_reading,
    input wire likes_technology,
    input wire likes_sports,
    input wire night_owl,
    input wire likes_making_others_laugh,
    input wire enjoys_solving_mysteries,
    output reg [10:0] traits // Each bit represents a trait
);

    always @(*) begin
        // Reset all traits
        traits = 11'b0;

        // Logical traits assignment using ~A & B
        traits[0] = ~enjoys_puzzles & 1;          // Logical Thinker
        traits[1] = ~likes_helping_others & 1;    // Empathetic
        traits[2] = ~adventurous & 1;             // Risk Taker
        traits[3] = ~prefers_working_alone & 1;   // Independent
        traits[4] = ~enjoys_art & 1;              // Creative
        traits[5] = ~likes_reading & 1;           // Knowledge Seeker
        traits[6] = ~likes_technology & 1;        // Tech Enthusiast
        traits[7] = ~likes_sports & 1;            // Active
        traits[8] = ~night_owl & 1;               // Nocturnal
        traits[9] = ~likes_making_others_laugh & 1; // Humorous
        traits[10] = ~enjoys_solving_mysteries & 1; // Detective Mind
    end
endmodule
