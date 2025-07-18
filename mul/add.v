module addr(
    input A, B, C,
    output out1, out2//1.s 2.carry
    );

assign out1 = ~A & ~B & C | ~A & B & ~C | A & ~B & ~C | A & B & C;
assign out2 = A & B | A & C | B & C;

endmodule