`timescale 1 ns / 1 ps

module BASYS3_FA(SUM, CARRY_OUT, A, B, CARRY_IN);
    output SUM, CARRY_OUT;
    input A, B, CARRY_IN;

    assign SUM = (A ^ B) ^ CARRY_IN;
    assign CARRY_OUT = (A & B) | (B & CARRY_IN) | (CARRY_IN & A);

endmodule