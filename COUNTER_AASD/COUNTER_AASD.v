/* Aaron Joseph Nanas
** ECE 526L | Spring 2021
** Lab 5: Reloadable 8-Bit Up Counter with AASD reset
** Professor Mehran
*/
`timescale 1ns / 1ps

module COUNTER_AASD(CLK, RESET_BTN, OUT);
    input CLK, RESET_BTN;
    output reg OUT;
    
    reg RESET_BTN1;
    
    always @(posedge CLK or negedge RESET_BTN)
        if (!RESET_BTN) begin // Asynchronous, active low reset
            RESET_BTN1 <= 1'b0;
            OUT <= 1'b0;
        end else begin
            RESET_BTN1 <= 1'b1;
            OUT <= RESET_BTN1;
        end         
endmodule


