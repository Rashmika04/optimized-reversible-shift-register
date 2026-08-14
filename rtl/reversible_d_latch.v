// ============================================================
// Reversible D Latch using Sayem Gate
//
// Based on the proposed design in:
// "Optimized Shift Register Design Using Reversible Logic"
//
// Sayem gate inputs:
//     A = CLK
//     B = previous Q
//     C = D
//     D = constant 0
//
// Sayem gate R output:
//
//     R = CLK'Q + CLK.D
//
// Therefore:
//
//     Q(t) = CLK'Q(t-1) + CLK.D
//
// This is the characteristic equation of the proposed
// reversible D latch.
// ============================================================

module reversible_d_latch (
    input  clk,
    input  d,
    output reg q
);

    // --------------------------------------------------------
    // Sayem gate outputs
    // --------------------------------------------------------

    wire garbage_p;
    wire gate_q;
    wire next_q;
    wire garbage_s;

    // --------------------------------------------------------
    // Sayem gate
    //
    // A = CLK
    // B = previous Q
    // C = D
    // D = constant 0
    //
    // R implements:
    //
    // R = CLK'Q + CLK.D
    // --------------------------------------------------------

    sayem_gate sg (
        .A(clk),
        .B(q),
        .C(d),
        .D(1'b0),

        .P(garbage_p),
        .Q(gate_q),
        .R(next_q),
        .S(garbage_s)
    );

    // --------------------------------------------------------
    // D Latch storage
    //
    // When CLK = 1, the latch is transparent and Q follows D.
    //
    // When CLK = 0, Q retains its previous value.
    //
    // The Sayem gate remains the combinational logic that
    // produces the required next-state function.
    // --------------------------------------------------------

    always @(*) begin
        if (clk)
            q = next_q;
    end

endmodule
