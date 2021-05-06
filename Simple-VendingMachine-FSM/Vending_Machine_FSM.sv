/* Aaron Joseph Nanas
** ECE 526
** Professor Orod Haghighiara
** Extra Credit FSM Assignment
** File: Vending_Machine_FSM.sv
** Description: Simple vending machine FSM.
** If the state is ITEM_DISPENSE, the output
** "o_ITEM" will be set high (1)
*/
`timescale 1ns / 1ps

module Vending_Machine_FSM(input logic i_CLK,
                           input logic i_RESET,
                           input logic i_DATA,
                           output logic o_ITEM);
                           
typedef enum logic [2:0] {IDLE, COIN_ENTERED, BUTTON_PRESSED, CANCEL, ITEM_DISPENSE} State;

State currentState, nextState;

// Sequential Logic
always_ff @(posedge i_CLK)
    if (i_RESET)
        currentState <= IDLE;
    else 
        currentState <= nextState;

// Combinational Logic       
always_comb
    case(currentState)
        IDLE: 
            if (i_DATA)   nextState = COIN_ENTERED; // Goes to next state if coins are inserted
            else          nextState = IDLE; // Otherwise, remains in IDLE state
              
        COIN_ENTERED: 
            if (i_DATA)   nextState = BUTTON_PRESSED; // When the amount is enough, allows user to press the selection
            else          nextState = COIN_ENTERED; // Otherwise, stay in the state
            
        BUTTON_PRESSED:   
            if (i_DATA)   nextState = ITEM_DISPENSE; // Upon selection, dispense the desired item
            else          nextState = CANCEL; // If user presses CANCEL (0), go to CANCEL state
        
        CANCEL:
            if (i_DATA)   nextState = IDLE; // Return coins when it is cancelled
            else          nextState = CANCEL;
            
        ITEM_DISPENSE:
            if (i_DATA)   nextState = IDLE; // After dispensing, go back to IDLE state
            else          nextState = IDLE;
        
        default:          nextState = IDLE;
    endcase

// Output logic
assign o_ITEM = (currentState == ITEM_DISPENSE);

endmodule
