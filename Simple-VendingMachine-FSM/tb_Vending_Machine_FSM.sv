/* Aaron Joseph Nanas
** ECE 526
** Professor Orod Haghighiara
** Extra Credit FSM Assignment
** File: tb_Vending_Machine_FSM.sv
** Description: Simple vending machine FSM.
** If the state is ITEM_DISPENSE, the output
** "o_ITEM" will be set high (1)
*/
`timescale 1ns / 1ps

module tb_Vending_Machine_FSM;
    parameter PERIOD = 10;
    
    logic i_CLK;
    logic i_RESET;
    logic i_DATA;
    logic o_ITEM;
    
    Vending_Machine_FSM UUT(
        .i_CLK(i_CLK),
        .i_RESET(i_RESET),
        .i_DATA(i_DATA),
        .o_ITEM(o_ITEM));
        
    initial
        i_CLK = 1'b0;
    always #(PERIOD/2) i_CLK = ~i_CLK;
    
    initial begin
        i_RESET = 1; i_DATA = 0;
        #(PERIOD) i_RESET = 0; i_DATA = 1;
        #(PERIOD) i_DATA = 1;
        #(PERIOD) i_DATA = 1;
        #(PERIOD) i_DATA = 0;
        #(PERIOD) i_DATA = 1;
        #(PERIOD) i_DATA = 1;
        #(PERIOD) i_DATA = 0;
        #(PERIOD) i_DATA = 1;
 
    end                 
endmodule
