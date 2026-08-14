// ============================================================
// Proposed Reversible D Flip-Flop
//
// Master-slave arrangement using two reversible D latches.
//
// The master is transparent when CLK = 0.
// The slave is transparent when CLK = 1.
//
// Therefore the output changes at the positive edge of CLK.
//
// ============================================================

module reversible_dff (
    input  clk,
    input  d,
    output wire q
);

    wire master_q;
    wire slave_clk;

    // Master latch is transparent when CLK = 0.
    assign slave_clk = clk;

    // Master uses inverted clock.
    reversible_d_latch master_latch (
        .clk(~clk),
        .d(d),
        .q(master_q)
    );

    // Slave is transparent when CLK = 1.
    reversible_d_latch slave_latch (
        .clk(slave_clk),
        .d(master_q),
        .q(q)
    );

endmodule
