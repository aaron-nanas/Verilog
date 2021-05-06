`timescale 1ns / 1ps

module RAM (ADDR, DATA, CS, WRITE_EN, OE);
    parameter WIDTH = 8;
    parameter DEPTH = 5;
    
    input [DEPTH-1:0] ADDR;
    inout [WIDTH-1:0] DATA;
    input CS, WRITE_EN, OE;
    
    reg [WIDTH-1:0] MEM [(2**DEPTH)-1:0];
    reg [WIDTH-1:0] DATA_OUT;

    assign DATA = (!CS && !WRITE_EN && !OE) ? DATA_OUT : 8'bz;
    
    // Writing to memory
    // CS = 0, WRITE_EN = 1, OE = 0
    always @*
    begin: RAM_WRITE
        if (!CS && WRITE_EN && !OE) begin // Active low CS signal
            MEM[ADDR] = DATA;
            DATA_OUT = {WIDTH{1'bz}};
        end
        else if (CS) begin
            MEM[ADDR] = {WIDTH{1'bz}};
        end
    end
    
    // Reading from memory
    // CS = 0, WRITE_EN = 0, OE = 1
    always @*
    begin: RAM_READ
        if (!CS && !WRITE_EN && OE) begin // Active high OE signal
            DATA_OUT = MEM[ADDR];
        end
        
        else if (CS) begin
            MEM[ADDR] = {WIDTH{1'bz}};
            DATA_OUT = {WIDTH{1'bz}};
        end
    end
    
endmodule



