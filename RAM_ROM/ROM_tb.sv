`timescale 1ns / 1ps
`define ROM_STR_1 "%d CS = %b, OE = %b, ADDR = %h | DATA = %h"
`define RAM_STR_3 "%d WRITE_EN = %b, CS_RAM = %b, OE_RAM = %b, ADDR_RAM = %h | DATA_RAM = %h, DATA_ROM = %h, DATA_ROM_OUT = %h" 

module ROM_tb();
    parameter WIDTH = 8;
    parameter DEPTH = 5; 
    parameter PERIOD = 10;

    // Signals for ROM
    reg [DEPTH-1:0] ADDR;
    reg CS, OE;
    wire [WIDTH-1:0] DATA;

    // Signals for RAM
    reg [DEPTH-1:0] ADDR_RAM;
    wire [WIDTH-1:0] DATA_RAM;
    reg CS_RAM, WRITE_EN, OE_RAM;
    
    reg [WIDTH-1:0] DATA_SIG;

    // module ROM(ADDR, CS, OE, DATA);
    ROM UUT1 (.ADDR(ADDR), .CS(CS), .OE(OE), .DATA(DATA));
    // module RAM (ADDR, DATA, CS, WRITE_EN, OE); 
    RAM UUT2 (.ADDR(ADDR_RAM), .DATA(DATA_RAM), .CS(CS_RAM), .WRITE_EN(WRITE_EN), .OE(OE_RAM));

    assign DATA_RAM = (!CS_RAM & !OE_RAM) ? DATA_SIG : {WIDTH{1'bz}};
    assign DATA = (!CS & !OE) ? DATA_SIG : {WIDTH{1'bz}};
    
    initial begin
        {ADDR_RAM, DATA_SIG, WRITE_EN, OE_RAM, OE, ADDR} = 0;
        CS_RAM = 1; CS = 1;

	#(PERIOD)
        $vcdpluson;
        $display("\nStarting the ROM Simulation\n");
	CS = 0; CS_RAM = 0; OE = 1; 

	$display("Reading initialized ROM values\n");
        for (integer i = 0; i < 2**DEPTH; i = i + 1) begin
            #(PERIOD) ADDR = i;
	    #(PERIOD) $strobe(`ROM_STR_1, $time, CS, OE, ADDR, DATA);
        end
	
        #(PERIOD) $display("Finished reading initialized ROM values\n");
        
        $display("Scrambling contents of ROM into RAM\n");
        #(PERIOD) WRITE_EN = 1;
        for (integer i = 0; i < 2**DEPTH; i= i + 1) begin
            #(PERIOD) ADDR = i;
            #(PERIOD) 
                DATA_SIG[7] = DATA[0];
                DATA_SIG[6] = DATA[7];
                DATA_SIG[5] = DATA[1];
                DATA_SIG[4] = DATA[6];
                DATA_SIG[3] = DATA[2];
                DATA_SIG[2] = DATA[5];
                DATA_SIG[1] = DATA[3];
                DATA_SIG[0] = DATA[4];
                ADDR_RAM = i;
            #(PERIOD) $strobe(`RAM_STR_3, $time, WRITE_EN, CS_RAM, OE_RAM, ADDR_RAM, DATA_RAM, DATA, RAM.DATA_OUT);
        end
        #(PERIOD) $strobe("\nFinished scrambling contents of ROM into RAM\n");
        

        #(PERIOD) $display("Reading the scrambled contents from RAM\n");
	OE_RAM = 1; WRITE_EN = 0;  
        $strobe(`RAM_STR_3, $time, WRITE_EN, CS_RAM, OE_RAM, ADDR_RAM, DATA_RAM, DATA, RAM.DATA_OUT);
        for (integer i = 0; i < 2**DEPTH; i = i + 1) begin
            #(PERIOD) ADDR_RAM= i;
            #(PERIOD) $strobe(`RAM_STR_3, $time, WRITE_EN, CS_RAM, OE_RAM, ADDR_RAM, DATA_RAM, DATA, RAM.DATA_OUT);
        end
        #(PERIOD) $display("\nSuccessfully read the scrambled contents from RAM\n");
        #(PERIOD) $strobe(`RAM_STR_3, $time, WRITE_EN, CS_RAM, OE_RAM, ADDR_RAM, DATA_RAM, DATA, RAM.DATA_OUT);
	CS = 1; CS_RAM = 1;
        #(PERIOD) $display("\nEnd of ROM Simulation\n");
        #(PERIOD) $finish;
     end

endmodule

