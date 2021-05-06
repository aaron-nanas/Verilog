`timescale 1ns / 1ps
`define FWFT

module SYNC_FIFO
#(  parameter WIDTH = 8,
    parameter DEPTH = 32,
    parameter p_ALMOST_FULL = 30,
    parameter p_ALMOST_EMPTY = 2
    )
    
(   input i_CLK, i_RESET,
    output reg [-1:DEPTH+1] o_COUNT,
    
    // Write Ports
    input i_WR_EN,
    input [WIDTH-1:0] i_WR_DATA,
    output reg o_ALMOST_FULL, o_FULL,
    
    // Read Ports
    input i_RD_EN,
    output reg [WIDTH-1:0] o_RD_DATA,
    output reg o_ALMOST_EMPTY, o_EMPTY,
    
    output reg VALID, OF, UF
    );
    
    reg [WIDTH-1:0] r_FIFO_DATA [0:DEPTH-1];
    reg [DEPTH-1:0] r_WRITE_INDEX, r_READ_INDEX;
    reg r_FULL, r_EMPTY, r_ALMOST_FULL, r_ALMOST_EMPTY;
    
    always @(posedge i_CLK) begin
        if (i_RESET) begin
            o_COUNT <= 0;
            r_WRITE_INDEX <= 0;
            r_READ_INDEX <= 0;
        end
    end
    
    // Writing to FIFO
    always @(posedge i_CLK) begin
        if (i_WR_EN == 1'b1 && i_RD_EN == 1'b1) begin // If writing to and reading from FIFO at the same time
            o_COUNT <= o_COUNT; // Make COUNT latch onto current value
            r_FIFO_DATA[r_READ_INDEX] <= i_WR_DATA;
            o_RD_DATA <= r_FIFO_DATA[r_READ_INDEX];
            r_WRITE_INDEX <= r_WRITE_INDEX + 1;
            r_READ_INDEX <= r_READ_INDEX + 1;
            VALID <= 1;
        
        end else if (i_WR_EN == 1'b1 && o_FULL == 1'b0 && i_RD_EN == 1'b0) begin
            r_WRITE_INDEX <= r_WRITE_INDEX + 1; // Increment Write Index
            o_COUNT <= o_COUNT + 1; // Increment FIFO count
		`ifdef FWFT
		    if (o_EMPTY) begin		
		    o_RD_DATA <= i_WR_DATA;
		    end
	        `endif
		
            r_FIFO_DATA[r_WRITE_INDEX] <= i_WR_DATA;
            VALID <= 0;
        
        end else if (i_RD_EN == 1'b1 && o_EMPTY == 1'b0 && i_WR_EN == 1'b0) begin
            r_READ_INDEX <= r_READ_INDEX + 1; // Increment Read Index   
            o_RD_DATA <= r_FIFO_DATA[r_READ_INDEX];
            o_COUNT <= o_COUNT - 1;
            VALID <= 1;
        
        end else if (i_RD_EN == 1'b0 && i_WR_EN == 1'b0) begin
            VALID <= 0;
	end

    end    
    
    // Setting flags
    always @(posedge i_CLK) begin
        if (!i_RESET) begin
            if (o_COUNT == DEPTH) begin
                o_FULL <= 1;
		if (i_WR_EN == 1'b1)
		    OF <= 1;
            end else begin   
                o_FULL <= 0;
		if (i_WR_EN == 1'b0)
                    OF <= 0;
	    end
            
            if (o_COUNT == 0) begin
                o_EMPTY <= 1;
                if (i_RD_EN == 1'b1)
                    UF <= 1;
            end else begin
                o_EMPTY <= 0;
	        if (i_RD_EN == 1'b0)
		    UF <= 0;
	    end
                
            if (o_COUNT > p_ALMOST_FULL) begin
                o_ALMOST_FULL <= 1;
            end else
                o_ALMOST_FULL <= 0;
                
            if (o_COUNT < p_ALMOST_EMPTY) begin
                o_ALMOST_EMPTY <= 1;
            end else
                o_ALMOST_EMPTY <= 0; 
                
    
        end else if (i_RESET) begin
            o_ALMOST_EMPTY <= 1;
            o_EMPTY <= 1;
            o_FULL <= 0;
            o_ALMOST_FULL <= 0;
            OF <= 0;
	    UF <= 1;
        end
                
    end

endmodule

