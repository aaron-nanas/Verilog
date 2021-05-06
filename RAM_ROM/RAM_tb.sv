`timescale 1ns / 1ps
`define RAM_STR_1 " %d WRITE_EN = %d, CS = %d, OE = %b, ADDR = %h | DATA = %h, DATA_SIG = %h, DATA_OUT = %h"
`define RAM_STR_2 " %d WRITE_EN = %d, CS = %d, OE = %b, ADDR = %h | DATA = %b, DATA_SIG = %b, DATA_OUT = %b"

module RAM_tb();
    parameter WIDTH = 8;
    parameter DEPTH = 5; 
    parameter PERIOD = 10;
    
    reg [DEPTH-1:0] ADDR;
    wire [WIDTH-1:0] DATA;
    reg CS, WRITE_EN, OE;
    
    reg [WIDTH-1:0] DATA_SIG;
    
    // module RAM (ADDR, DATA, CS, WRITE_EN, OE); 
    RAM UUT1 (.ADDR(ADDR), .DATA(DATA), .CS(CS), .WRITE_EN(WRITE_EN), .OE(OE));
    
    assign DATA = (!CS & !OE) ? DATA_SIG : {WIDTH{1'bz}};
    
  //$strobe(`RAM_STR_1, $time, WRITE_EN, CS, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
  //$strobe(`RAM_STR_2, $time, WRITE_EN, CS, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
    //initial begin 
	//$monitor (`RAM_STR_1, $time, WRITE_EN, CS, OE, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
    //end
    
    initial begin
        $vcdpluson;
        {WRITE_EN, ADDR, DATA_SIG, OE} = 0;
        CS = 1;
        
        $display("\n\tStarting the Simulation\n");
        $display("\tWriting to RAM: Sequential Numbering Simulation\n");
        #(PERIOD) CS = 0; WRITE_EN = 1; OE = 0;
        for (integer i = 0; i < 32; i = i + 1) begin
            #(PERIOD) ADDR = i;
            #(PERIOD) DATA_SIG = i;
	$strobe (`RAM_STR_1, $time, WRITE_EN, CS, OE, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
        end
        #(PERIOD) $display ("\n\tFinished writing to RAM sequentially\n\n");
        OE = 0;
        $display("\tReading memory . . .\n");
        #(PERIOD) WRITE_EN = 0; OE = 1;
	$strobe (`RAM_STR_1, $time, WRITE_EN, CS, OE, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
        for (integer i = 0; i < 32; i = i + 1) begin
            #(PERIOD) ADDR = i;
	$strobe (`RAM_STR_1, $time, WRITE_EN, CS, OE, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
        end
        #(PERIOD) $display("\n\tFinished the Sequential Block Read.\n");
	$display("\n\tDemonstrating Walking Ones\n");
        
        #(PERIOD) WRITE_EN = 1; OE = 0;
	$strobe (`RAM_STR_1, $time, WRITE_EN, CS, OE, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
        for (integer i = 0; i < WIDTH; i = i + 1) begin
            #(PERIOD) ADDR = i;
            #(PERIOD) DATA_SIG = 2**i;
	$strobe (`RAM_STR_2, $time, WRITE_EN, CS, OE, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
        end
        
        #(PERIOD) WRITE_EN = 1;
	$strobe (`RAM_STR_2, $time, WRITE_EN, CS, OE, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
        #(PERIOD) WRITE_EN = 0; OE = 1;
	$strobe("\n\tReading Walking Ones output\n");
	$strobe (`RAM_STR_2, $time, WRITE_EN, CS, OE, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
        for (integer i = 0; i < WIDTH; i = i + 1) begin
            #(PERIOD) ADDR = i;
            #(PERIOD) 
	$strobe (`RAM_STR_2, $time, WRITE_EN, CS, OE, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
        end
        
        #(PERIOD) $strobe("\n\tFinished reading Walking Ones\n");
	
	$monitor (`RAM_STR_1, $time, WRITE_EN, CS, OE, ADDR, DATA, DATA_SIG, RAM.DATA_OUT);
        #(PERIOD) CS = 1'b1;
	$display("\n\tShowing disabled state\n");   
        #(PERIOD) ADDR = 5'b00000; DATA_SIG = 8'b00001111; OE = 1'b0;
        #(PERIOD) WRITE_EN = 1'b1;
        #(PERIOD) OE = 1'b1; WRITE_EN = 1'b0;
        #(PERIOD) CS = 1'b0;
        #(PERIOD) CS = 1'b1;

        #(PERIOD) $display("\n\tEnd of Simulation\n\n");
        $finish;
    end
endmodule

