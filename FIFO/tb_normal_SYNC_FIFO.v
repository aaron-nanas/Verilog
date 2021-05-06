`timescale 1ns / 1ps
`define FIFO_STR_1 " %d RESET = %d, CLK = %d, COUNT = %d | WR_EN = %d, DATA_IN = %h, AF = %d, FULL = %d | RD_EN = %d, DATA_OUT = %h, VALID = %d, AE = %d, EMPTY = %d | OF = %d, UF = %d "

module tb_SYNC_FIFO();
    parameter WIDTH = 8;
    parameter DEPTH = 32;
    parameter p_ALMOST_FULL = 30;
    parameter p_ALMOST_EMPTY = 2;
    parameter PERIOD = 10;
    
    integer k;
    
    reg i_CLK, i_RESET;
    wire [-1:DEPTH+1] o_COUNT;
        
    // Write Ports
    reg i_WR_EN;
    reg [WIDTH-1:0] i_WR_DATA;
    wire o_ALMOST_FULL, o_FULL;
        
    // Read Ports
    reg i_RD_EN;
    wire [WIDTH-1:0] o_RD_DATA;
    wire o_ALMOST_EMPTY, o_EMPTY;
        
    wire VALID, OF, UF;
    
    SYNC_FIFO UUT
        (.i_CLK(i_CLK),
         .i_RESET(i_RESET),
         .o_COUNT(o_COUNT),
         // Write Ports
         .i_WR_EN(i_WR_EN),
         .i_WR_DATA(i_WR_DATA),
         .o_ALMOST_FULL(o_ALMOST_FULL),
         .o_FULL(o_FULL),
         // Read Ports
         .i_RD_EN(i_RD_EN),
         .o_RD_DATA(o_RD_DATA),
         .o_ALMOST_EMPTY(o_ALMOST_EMPTY),
         .o_EMPTY(o_EMPTY),
         .VALID(VALID),
         .OF(OF),
         .UF(UF)
         );  
         
    initial begin
        $monitor(`FIFO_STR_1, $time, i_RESET, i_CLK, o_COUNT, i_WR_EN, i_WR_DATA, o_ALMOST_FULL, o_FULL, i_RD_EN, o_RD_DATA, VALID, o_ALMOST_EMPTY, o_EMPTY, OF, UF);
    end
         
    initial
        i_CLK = 1'b0;
    always #(PERIOD/2) i_CLK = ~i_CLK;   
    
    initial begin
        $vcdpluson;
        $write("\n\tStarting the Simulation\n");
        i_RESET = 1; i_WR_EN = 0; i_RD_EN = 1;

        $write("\n\tShowing Underflow flag\n");
	#(PERIOD) i_RESET = 0;
	
	`ifdef FWFT
	#(PERIOD) i_WR_EN = 1; i_RD_EN = 0; i_WR_DATA = 'h65;

	#(PERIOD) $write("\n\tWriting FIFO Data\n");
        
        for (k = 0; k < DEPTH; k = k + 1) begin
            #(PERIOD) i_WR_DATA = 'h1A + k;
        end
        
        i_WR_EN = 0; i_RD_EN = 1;
        $write("\n\tReading FIFO Data\n");
        #((DEPTH-1)*PERIOD) i_RD_EN = 0;
        #(PERIOD) i_WR_EN = 1;
        
        $write("\n\tShowing Simultaneous Read and Write\n");
        #((WIDTH-1)*PERIOD) i_WR_EN = 1; i_RD_EN = 1;
        #((WIDTH-1)*PERIOD) i_RD_EN = 0;
        #((WIDTH-1)*PERIOD) i_WR_EN = 0;
        #((WIDTH-1)*PERIOD) i_RD_EN = 1;
        #((WIDTH-1)*PERIOD) i_RD_EN = 0;

	`else
	i_WR_DATA = 0;
	#(PERIOD) i_WR_EN = 1; i_RD_EN = 0;

	$write("\n\tWriting FIFO Data\n");
        
        for (k = 0; k < DEPTH; k = k + 1) begin
            #(PERIOD) i_WR_DATA = 'h1A + k;
        end
        
        i_WR_EN = 0; i_RD_EN = 1;
        $write("\n\tReading FIFO Data\n");
        #((DEPTH-1)*PERIOD) i_RD_EN = 0;
        #(PERIOD) i_WR_EN = 1;
        
        $write("\n\tShowing Simultaneous Read and Write\n");
	for (k = 0; k < DEPTH; k = k + 1) begin
		#(PERIOD) i_WR_DATA = 'h01 + k;
	end
        #((WIDTH-1)*PERIOD) i_WR_EN = 1; i_RD_EN = 1;
        #((WIDTH-1)*PERIOD) i_RD_EN = 0;
        #((WIDTH-1)*PERIOD) i_WR_EN = 0;
        #((WIDTH-1)*PERIOD) i_RD_EN = 1;
        #((WIDTH-1)*PERIOD) i_RD_EN = 0;
	
        
        #(PERIOD) $write("\nEnd of Simulation\n");
	`endif
	$finish;
   
    end                    
    
endmodule

