/*
*   Aaron Nanas
*   ECE 526L
*   Lab 3: Hierarchical Modeling
*   Spring 2021
*   Description: Modeling a DFF using a NAND-based SR Latch
*/

`timescale 1 ns / 100 ps

`define MONITOR_STR_1 "%d: CLR = %d, CLK = %d, D = %d | Q = %d, Q_BAR = %d"

module DFF_tb();
    reg CLR, CLK, D;
    wire Q, Q_BAR;

    DFF d_ff(.Q(Q), .Q_BAR(Q_BAR), .CLR(CLR), .CLK(CLK), .D(D));

    initial begin
    $monitor (`MONITOR_STR_1, $time, CLR, CLK, D, Q, Q_BAR);
    end

    initial begin
    $vcdpluson; // For graphical viewer (waveforms)
    $write("\nReset the DFF\n");
    #50 CLR = 1'b0;
	CLK = 1'b0;
        D   = 1'b0;

    #50 CLR = 1'b0;
	CLK = 1'b1;
        D   = 1'b0;

    #50 CLR = 1'b0;
	CLK = 1'b0;
        D   = 1'b0;

    #50 CLR = 1'b0;
	CLK = 1'b1;
        D   = 1'b0;

    #50 CLR = 1'b1;
	CLK = 1'b0;
        D   = 1'b0;

    #50 CLR = 1'b1;
	CLK = 1'b1;
        D   = 1'b0; 

    #50 CLR = 1'b1;
	CLK = 1'b0;
        D   = 1'b0;

    $write("\nTesting inputs after reset\n");

    #50 CLR = 1'b1;
	CLK = 1'b1;
        D   = 1'b0;

    #50 CLR = 1'b1;
	CLK = 1'b0;
        D   = 1'b1;

    #50 CLR = 1'b1;
	CLK = 1'b1;
        D   = 1'b1;

    #50 CLR = 1'b1;
	CLK = 1'b0;
        D   = 1'b0;

    #50 CLR = 1'b1;
	CLK = 1'b1;
        D   = 1'b0;

    #50 CLR = 1'b1;
	CLK = 1'b0;
        D   = 1'b1;

    #50 CLR = 1'b1;
	CLK = 1'b1;
        D   = 1'b0;

    #50 CLR = 1'b1;
	CLK = 1'b0;
        D   = 1'b0;

    #50 CLR = 1'b1;
	CLK = 1'b1;
        D   = 1'b1;

    #50 CLR = 1'b1;
	CLK = 1'b0;
        D   = 1'b0;

    $write ("\nReset and test again\n");

    #50 CLR = 1'b0;
	CLK = 1'b1;
	D   = 1'b0;
    #50 CLR = 1'b1;
        CLK = 1'b0;
        D   = 1'b0;
    #50 CLR = 1'b1;
        CLK = 1'b1;
        D   = 1'b1;
    #50 CLR = 1'b1;
        CLK = 1'b0;
        D   = 1'b0;
    
    $display("\nDisplaying latch behavior\n");

    #50 CLR = 1'b1;
	CLK = 1'b1;
        D   = 1'b1;

    #50 CLR = 1'b1;
	CLK = 1'b0;
        D   = 1'b1;

    #50 CLR = 1'b1;
	CLK = 1'b1;
        D   = 1'b0;

    #50 CLR = 1'b1;
	CLK = 1'b0;
        D   = 1'b1;
   
    #50 CLR = 1'b0;
	CLK = 1'b1;
        D   = 1'b0;
    $write("\nReset\n");

    #50 CLR = 1'b0;
	CLK = 1'b0;
        D   = 1'b0;

    #50 CLR = 1'b1;
	CLK = 1'b1;
        D   = 1'b0;

    #50 CLR = 1'b1;
	CLK = 1'b0;
        D   = 1'b1;

    #50 $strobe("\nEnd of DFF Simulation\n");
    #50 $finish;
    end
    
endmodule
