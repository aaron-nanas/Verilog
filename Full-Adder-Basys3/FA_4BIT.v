`timescale 1 ns / 10 ps

module FA_4BIT(SUM, A, B);

    input [3:0] A, B;
    output [4:0] SUM;

    wire C0, C1, C2;

    BASYS3_FA FA0 (.SUM(SUM[0]), .CARRY_OUT(C0), .A(A[0]), .B(B[0]), .CARRY_IN(1'b0));
    BASYS3_FA FA1 (.SUM(SUM[1]), .CARRY_OUT(C1), .A(A[1]), .B(B[1]), .CARRY_IN(C0));
    BASYS3_FA FA2 (.SUM(SUM[2]), .CARRY_OUT(C2), .A(A[2]), .B(B[2]), .CARRY_IN(C1));
    BASYS3_FA FA3 (.SUM(SUM[3]), .CARRY_OUT(SUM[4]), .A(A[3]), .B(B[3]), .CARRY_IN(C2));

endmodule