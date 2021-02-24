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
module DFF(Q, Q_BAR, CLK, D, CLR);
    
   output Q, Q_BAR;
	input CLK, D, CLR;
	wire CLR_BAR, CLK_BAR, D_BAR, CLR1, CLK1, D1, S_BAR, S, R, R_BAR;

	// Top set of NOT gates
	not #(`TIME_DELAY_1 + `FAN_OUT_1) NOT1(CLR_BAR, CLR);
	not #(`TIME_DELAY_1 + `FAN_OUT_3) NOT2(CLR1, CLR_BAR);

	// Middle set of NOT gates
	not #(`TIME_DELAY_1 + `FAN_OUT_1) NOT3(CLK_BAR, CLK);
	not #(`TIME_DELAY_1 + `FAN_OUT_2) NOT4(CLK1, CLK_BAR);

	// Bottom set of NOT gates
	not #(`TIME_DELAY_1 + `FAN_OUT_1) NOT5(D_BAR, D);
	not #(`TIME_DELAY_1 + `FAN_OUT_1) NOT6(D1, D_BAR);

	// Instantiating SR_LATCH module (Q, Q_BAR, S0, S1, R0, R1)
	SR_LATCH sr_latch1 (.Q(S_BAR), .Q_BAR(S), .S0(R_BAR), .S1(1'b1), .R0(CLK1), .R1(CLR1));
	SR_LATCH sr_latch2 (.Q(R), .Q_BAR(R_BAR), .S0(S), .S1(CLK1), .R0(D1), .R1(CLR1));
	SR_LATCH sr_latch3 (.Q(Q), .Q_BAR(Q_BAR), .S0(S), .S1(1'b1), .R0(R), .R1(CLR1));

	defparam sr_latch1.DELAY_1 = `TIME_DELAY_3 +`FAN_OUT_1;
	defparam sr_latch1.DELAY_2 = `TIME_DELAY_3 +`FAN_OUT_3;
	defparam sr_latch2.DELAY_1 = `TIME_DELAY_3 + `FAN_OUT_2;
	defparam sr_latch2.DELAY_2 = `TIME_DELAY_3 + `FAN_OUT_2;
	defparam sr_latch3.DELAY_1 = `TIME_DELAY_3 + `FAN_OUT_1 + `PRIMARY_OUT;
	defparam sr_latch3.DELAY_2 = `TIME_DELAY_3 + `FAN_OUT_1 + `PRIMARY_OUT;

endmodule
