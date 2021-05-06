/* Aaron Joseph Nanas
** ECE 526L | Spring 2021
** Lab 5: Reloadable 8-Bit Up Counter with AASD reset
** Professor Mehran
*/
`timescale 1ns / 1ps

module COUNTER_TOP (CLK, RESET, ENA, LOAD, DATA, COUNT);

    input CLK, RESET, ENA, LOAD;
    input wire [7:0] DATA;
    output wire [7:0] COUNT;
    
    wire w_RESET;
    
    COUNTER_UP      COUNTER1 (.CLK(CLK), .RESET(w_RESET), .ENA(ENA), .LOAD(LOAD), .DATA(DATA), .COUNT(COUNT));
    COUNTER_AASD    COUNTER2 (.CLK(CLK), .RESET_BTN(RESET), .OUT(w_RESET));
    
endmodule


