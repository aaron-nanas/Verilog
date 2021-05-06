/* Aaron Joseph Nanas
** ECE 526L | Spring 2021
** Lab 5: Reloadable 8-Bit Up Counter with AASD reset
** Professor Mehran
*/
`timescale 1ns / 1ps

module COUNTER_UP (CLK, RESET, ENA, LOAD, DATA, COUNT);
    
    input CLK, RESET, ENA, LOAD;
    input wire [7:0] DATA;
    output reg [7:0] COUNT;
    
always @(posedge CLK or negedge RESET) begin
    if (!RESET)  // Asynchronous, active low 
        COUNT <= 0;
    else if (!ENA) // Synchronous, active high enable
        COUNT <= COUNT; // Holding value when not asserted
    else if (ENA == 1) begin
        if (LOAD == 1) begin
            COUNT <= DATA;
        end
    else if (COUNT >= 2**(8))
        COUNT <= 0;
    else
        COUNT <= COUNT + 1;
    end
end

endmodule


