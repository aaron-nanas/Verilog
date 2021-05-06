`timescale 1ns / 1ps

module ALU(CLK, EN, OE, OPCODE, A, B, ALU_OUT, CF, OF, SF, ZF);
    parameter WIDTH = 8;

    input CLK, EN, OE;
    input [3:0] OPCODE;
    
    //`ifdef SIGNED
        input signed [WIDTH-1:0] A, B;
        output signed [WIDTH-1:0] ALU_OUT;
    //`else
        //input [WIDTH-1:0] A, B;
        //output [WIDTH-1:0] ALU_OUT;
    //`endif
    
    output CF, OF, SF, ZF; // Carry Flag, Overflow Flag, Signed Flag, Zero Flag
    
    wire [WIDTH-1:0] B_twos_complement;
    reg [WIDTH:0] ALU_OUT_SIG; // Factoring in overflow bit
    
    //---------------------------------------------------------------------------
    // Localparam Definitions
    //---------------------------------------------------------------------------
    localparam ALU_OUT_SUM =       4'b0010;
    localparam ALU_OUT_SUBTRACT =  4'b0011;
    localparam ALU_OUT_AND =       4'b0100;
    localparam ALU_OUT_OR =        4'b0101;
    localparam ALU_OUT_XOR =       4'b0110;
    localparam ALU_OUT_NOT_A =     4'b0111;

    assign B_twos_complement = ~B + 1'b1;
    assign ALU_OUT = (OE == 1) ? ALU_OUT_SIG[WIDTH-1:0] : {WIDTH{1'bz}}; // High impedance when OE = 0
    assign ZF = (ALU_OUT_SIG == 0) ? 1 : 0; // Set zero flag high when output is 0
    assign SF = (ALU_OUT_SIG[WIDTH-1] == 1) ? 1 : 0; // Checks if MSB is 1 or 0
    assign OF = (((A[WIDTH-1] ^ B[WIDTH-1]) == 0) && (ALU_OUT_SIG[WIDTH-1] != A[WIDTH-1])) ? 1 : 0; // Checks if result will have overflow bit
    assign CF = (((OPCODE == ALU_OUT_SUM) && (ALU_OUT_SIG[WIDTH]) == 1) || ((OPCODE == ALU_OUT_SUBTRACT) && A < B)) ? 1 : 0; // Checks for carry when adding or subtracting
    
    // Overflow and Carry flags are only updated on arithmetic operations
    // Signed and Zero flags are updated on arithmetic and Boolean operations
    always @(posedge CLK) begin
        if (EN) begin
            case (OPCODE)
                ALU_OUT_SUM :       ALU_OUT_SIG <= A + B;
                ALU_OUT_SUBTRACT :  ALU_OUT_SIG <= A + B_twos_complement;
                ALU_OUT_AND :       ALU_OUT_SIG <= A & B;
                ALU_OUT_OR :        ALU_OUT_SIG <= A | B;
                ALU_OUT_XOR :       ALU_OUT_SIG <= A ^ B;
                ALU_OUT_NOT_A :     ALU_OUT_SIG <= ~A;
                default:            begin
                    ALU_OUT_SIG <= 0; // Default value of 0 when invalid OPCODE is chosen
                    $display("\n%d: Error! OPCODE input is invalid. Please enter a valid OPCODE (between 2-7)\n", $time);
                end
            endcase
        end

        else if (!EN)
            ALU_OUT_SIG <= ALU_OUT_SIG; // Retains ALU output value
    end
    
endmodule

