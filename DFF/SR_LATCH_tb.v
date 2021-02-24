/*
*   Aaron Nanas
*   ECE 526L
*   Lab 3: Hierarchical Modeling
*   Spring 2021
*   Description: Modeling a DFF using a NAND-based SR Latch
*/

`timescale 1 ns / 1 ns

`define MONITOR_STR_1 "%d: S0 = %b, S1 = %b, R0 = %b, R1 = %b | Q = %b, Q_BAR = %b"

module SR_LATCH_tb();

	reg S0, S1, R0, R1;	
	wire Q, Q_BAR;

	SR_LATCH srlatch1 (Q, Q_BAR, S0, S1, R0, R1);

	initial begin
		$monitor (`MONITOR_STR_1, $time, S0, S1, R0, R1, Q, Q_BAR);
	end

	initial begin
	$vcdpluson;

	// Start at 0
	#20 S0 = 0; S1 = 0; R0 = 0; R1 = 0;
	#20 S0 = 0; S1 = 0; R0 = 0; R1 = 1;
	#20 S0 = 0; S1 = 0; R0 = 1; R1 = 0;
	#20 S0 = 0; S1 = 0; R0 = 1; R1 = 1;
	#20 S0 = 0; S1 = 1; R0 = 0; R1 = 0;
	#20 S0 = 0; S1 = 1; R0 = 0; R1 = 1;
	#20 S0 = 0; S1 = 1; R0 = 1; R1 = 0;
	#20 S0 = 0; S1 = 1; R0 = 1; R1 = 1;
	#20 S0 = 1; S1 = 0; R0 = 0; R1 = 0;
	#20 S0 = 1; S1 = 0; R0 = 0; R1 = 1;
	#20 S0 = 1; S1 = 0; R0 = 1; R1 = 0;
	#20 S0 = 1; S1 = 0; R0 = 1; R1 = 1;
	#20 S0 = 1; S1 = 1; R0 = 0; R1 = 0;
	#20 S0 = 1; S1 = 1; R0 = 0; R1 = 1;
	#20 S0 = 1; S1 = 1; R0 = 1; R1 = 0;
	#20 S0 = 1; S1 = 1; R0 = 1; R1 = 1;
	#20 S0 = 1; S1 = 1; R0 = 0; R1 = 0;
	#20 S0 = 0; S1 = 0; R0 = 1; R1 = 1;
	#20 $finish;
	end
endmodule
