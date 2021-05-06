`timescale 1ns / 1ps
`define ALU_STR_1 "%d CLK = %b, EN = %b, OE = %b, OPCODE = %d, A = %d, B = %d, ALU_OUT = %d | CF = %b, OF = %b, SF = %b, ZF = %b"

module ALU_tb();
    parameter WIDTH = 8;
    parameter PERIOD = 10;
    
    localparam ALU_OUT_SUM =       4'b0010;
    localparam ALU_OUT_SUBTRACT =  4'b0011;
    localparam ALU_OUT_AND =       4'b0100;
    localparam ALU_OUT_OR =        4'b0101;
    localparam ALU_OUT_XOR =       4'b0110;
    localparam ALU_OUT_NOT_A =     4'b0111;
    
    reg CLK, EN, OE;
    reg [3:0] OPCODE;
    
    //`ifdef SIGNED
        reg signed [WIDTH-1:0] A, B;
        wire signed [WIDTH-1:0] ALU_OUT;
    //`else
        //reg [WIDTH-1:0] A, B;
        //wire [WIDTH-1:0] ALU_OUT;
    //`endif
    
    wire CF, OF, SF, ZF; // Carry Flag, Overflow Flag, Signed Flag, Zero Flag
    
    ALU UUT1 (.CLK(CLK), .EN(EN), .OE(OE), .OPCODE(OPCODE), .A(A), .B(B), .ALU_OUT(ALU_OUT), .CF(CF), .OF(OF), .SF(SF), .ZF(ZF));

    initial begin
        $monitor(`ALU_STR_1, $time, CLK, EN, OE, OPCODE, A, B, ALU_OUT, CF, OF, SF, ZF);
    end
    
    initial
    CLK = 1'b0;
    always #(PERIOD/2) CLK = ~CLK;

    initial begin
	$vcdpluson;
        {CLK, EN, OE, OPCODE, A, B} <= 0;
        $display("\n\tStarting the Simulation\n");
        #(PERIOD) EN = 1'b1; OE = 1; 
        
        for (integer i = 0; i < WIDTH-1; i = i + 1) begin
            #(PERIOD) OPCODE = ALU_OUT_SUM + i;
	    if (OPCODE == ALU_OUT_SUM)
                $display("\n\tShowing ALU Addition Operation\n");

	    else if (OPCODE == ALU_OUT_SUBTRACT)
    		$display("\n\tShowing ALU Subtraction Operation\n");

	    else if (OPCODE == ALU_OUT_AND)
    		$display("\n\tShowing ALU AND Operation\n");

	    else if (OPCODE == ALU_OUT_OR)
    		$display("\n\tShowing ALU OR Operation\n");

	    else if (OPCODE == ALU_OUT_XOR)
    		$display("\n\tShowing ALU XOR Operation\n");

	    else if (OPCODE == ALU_OUT_NOT_A)
    		$display("\n\tShowing ALU NOT_A Operation\n");

            #(PERIOD) A = 8'b00000011; B = 8'b00000001; // 3 and 1
            #(PERIOD) A = 8'b00001111; B = 8'b00001111; // 15 and 15
            #(PERIOD) A = 8'b10101010; B = 8'b01010101; // 170 and 85
            #(PERIOD) A = 8'b00000011; B = 8'b11110000; // 3 and 240
            #(PERIOD) A = 8'b00000000; B = 8'b00000000; // 0 and 0
            #(PERIOD) A = 8'b11111111; B = 8'b11111111; // 255 and 255
        end
      
        #(PERIOD) $display("\n\tDisabling ALU\n");
	OE = 1'b0; EN = 1'b0;
        #(PERIOD) $strobe("\n\tEnd of ALU Simulation\n");
	#(PERIOD) $finish;

    end 
    
endmodule

