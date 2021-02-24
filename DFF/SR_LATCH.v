/*
*   Aaron Nanas
*   ECE 526L
*   Lab 3: Hierarchical Modeling
*   Spring 2021
*   Description: Modeling a DFF using a NAND-based SR Latch
*/

`timescale 1 ns / 100 ps
`include "time_delays.v"

// Declaring module ports
module SR_LATCH (Q, Q_BAR, S0, S1, R0, R1);
	parameter DELAY_1 = 0;
	parameter DELAY_2 = 0;
	
	input S0, S1, R0, R1;
	output Q, Q_BAR;

	nand #(DELAY_1) NAND1(Q, S0, S1, Q_BAR);
	nand #(DELAY_2) NAND2(Q_BAR, R0, R1, Q);

endmodule


