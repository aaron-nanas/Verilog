`timescale 1ns / 1ps

module ROM(ADDR, CS, OE, DATA);

    parameter WIDTH = 8;
    parameter DEPTH = 5;
    
    input [DEPTH-1:0] ADDR;
    input CS, OE;
    output reg [WIDTH-1:0] DATA;
    
    reg [WIDTH-1:0] ROM_MEM [(2**DEPTH)-1:0];
    
    initial begin
        $readmemh("ROM_init.mem", ROM_MEM);
    end
    
    always @*
    begin ROM_READ:
        if (!CS) begin
            if (OE) begin
                DATA = ROM_MEM[ADDR];
            end else begin
                DATA = {WIDTH{1'bz}};
            end
        end else begin
            DATA = {WIDTH{1'bz}};
            ROM_MEM[ADDR] = {WIDTH{1'bz}};
        end
    end
        
endmodule

