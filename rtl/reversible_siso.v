// ============================================================
// 4-bit Reversible SISO Shift Register
//
// Serial-In Serial-Out shift register.
//
// Structure:
//
// Serial In -> DFF1 -> DFF2 -> DFF3 -> DFF4 -> Serial Out
//
// Based on the proposed reversible SISO architecture.
// ============================================================

module reversible_siso (
    input  clk,
    input  serial_in,
    output wire serial_out,
    output wire [3:0] q
);

    // --------------------------------------------------------
    // Four reversible D flip-flops
    // --------------------------------------------------------

    reversible_dff dff1 (
        .clk(clk),
        .d(serial_in),
        .q(q[0])
    );

    reversible_dff dff2 (
        .clk(clk),
        .d(q[0]),
        .q(q[1])
    );

    reversible_dff dff3 (
        .clk(clk),
        .d(q[1]),
        .q(q[2])
    );

    reversible_dff dff4 (
        .clk(clk),
        .d(q[2]),
        .q(q[3])
    );

    // Rightmost flip-flop provides serial output
    assign serial_out = q[3];

endmodule
