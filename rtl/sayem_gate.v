// ============================================================
// Sayem Reversible Gate
// 4x4 reversible logic gate
//
// Based on:
// "Optimized Shift Register Design Using Reversible Logic"
// ============================================================

module sayem_gate (
    input  A,
    input  B,
    input  C,
    input  D,
    output P,
    output Q,
    output R,
    output S
);

    // Sayem gate equations
    assign P = A;
    assign Q = (~A & B) ^ (A & C);
    assign R = (~A & B) ^ (A & C) ^ D;
    assign S = (A & B) ^ (~A & C) ^ D;

endmodule