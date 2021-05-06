/* Aaron Joseph Nanas
** ECE 526L | Spring 2021
** Lab 5: Reloadable 8-Bit Up Counter with AASD reset
** Professor Mehran
*/
`timescale 1ns / 1ps
`define MONITOR_STR_1 "%d RESET = %b, ENA = %b, CLK = %b, LOAD = %b, DATA = %b | COUNT = %b"

module COUNTER_TOP_tb();
    
    reg CLK, RESET, ENA, LOAD;
    reg [7:0] DATA;
    wire [7:0] COUNT;
    
    // Instantiates top level design
    COUNTER_TOP counter(.CLK(CLK), .RESET(RESET), .ENA(ENA), .LOAD(LOAD), .DATA(DATA), .COUNT(COUNT));  
    
    initial begin
	$monitor (`MONITOR_STR_1, $time, RESET, ENA, CLK, LOAD, DATA, COUNT);
    end

    // Clock generator with a 20 ns period                
    initial
    CLK = 1'b0;
    always #10 CLK = ~CLK;
   
   initial begin
	$vcdpluson;
   $write( "\nStarting the simulation");
   ENA = 1'b0; LOAD = 1'b0; RESET = 1'b0; DATA = 8'b00000000;
   #20 ENA = 1'b1; LOAD = 1'b0; RESET = 1'b1;

   // After it reaches a count of 8, load the value 250
   $write ("\nLoading decimal value of 250\n");
   #210 ENA = 1'b1; LOAD = 1'b1; DATA = 8'b11111010;
   // Set LOAD to low and it will increment by 1 from 250
   #20 LOAD = 1'b0; DATA = 8'b00000000;
   $write ("\nShowing that COUNT will hold value when ENA = 0\n");
   #60 ENA = 1'b0; // Demonstrate that when ENA = 0, COUNT will hold its value
   #40 RESET = 1'b1;
   #20 ENA = 1'b1;
   $write ("\nTesting ENA = 0 again\n");
   #60 ENA = 1'b0;
   #40 ENA = 1'b1;
   // Show that when RESET is active low, it will not load or increment
   $write ("\nShowing that when RESET = 0, it will not load data or increment\n");
   #100 RESET = 1'b0; DATA = 8'b01010110; LOAD = 1'b1;
   #20 LOAD = 1'b0; RESET = 1'b1;
   #100 LOAD = 1'b1;
   $write ("\nShowing again that LOAD is functioning correctly\n");
   #20 LOAD = 1'b0;
   $write ("\nResetting to see if the counter is initialized to 0 again\n");
   #100 RESET = 1'b0;
   #20 RESET = 1'b1;
   #20 ENA = 1'b0;
   #80 ENA = 1'b1;
   #200 $finish;
   $strobe("\nEnd of Simulation\n");
   
   end
endmodule





