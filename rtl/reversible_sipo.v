// ============================================================
// 4-bit Reversible SIPO Shift Register
//
// Serial-In Parallel-Out
//
// Structure:
//
// Serial In
//    |
//   DFF1 ---> O0
//    |
//   Feynman Gate
//    |
//   DFF2 ---> O1
//    |
//   Feynman Gate
//    |
//   DFF3 ---> O2
//    |
//   Feynman Gate
//    |
//   DFF4 ---> O3
//
// Based on the proposed reversible SIPO architecture.
// ============================================================


// ============================================================
// Feynman Reversible Gate
//
// 2 x 2 reversible gate:
//
// P = A
// Q = A ^ B
//
// When B = 0:
// Q = A
//
// Therefore it can copy the signal while preserving
// reversibility.
// ============================================================

module feynman_gate (
    input  A,
    input  B,
    output P,
    output Q
);

    assign P = A;
    assign Q = A ^ B;

endmodule


// ============================================================
// 4-bit Reversible SIPO Shift Register
// ============================================================

module reversible_sipo (
    input clk,
    input serial_in,

    output wire [3:0] parallel_out,

    output wire q0,
    output wire q1,
    output wire q2,
    output wire q3
);

    wire dff1_q;
    wire dff2_q;
    wire dff3_q;
    wire dff4_q;

    wire fg1_out;
    wire fg2_out;
    wire fg3_out;

    // --------------------------------------------------------
    // First reversible D flip-flop
    //
    // Serial input enters the first stage.
    // --------------------------------------------------------

    reversible_dff dff1 (
        .clk(clk),
        .d(serial_in),
        .q(dff1_q)
    );

    // Parallel output of first stage
    assign q0 = dff1_q;

    // --------------------------------------------------------
    // Feynman gate 1
    //
    // B = 0, so the second output copies dff1_q.
    // --------------------------------------------------------

    feynman_gate fg1 (
        .A(dff1_q),
        .B(1'b0),
        .P(fg1_out),
        .Q()
    );

    // --------------------------------------------------------
    // Second reversible D flip-flop
    // --------------------------------------------------------

    reversible_dff dff2 (
        .clk(clk),
        .d(fg1_out),
        .q(dff2_q)
    );

    assign q1 = dff2_q;

    // --------------------------------------------------------
    // Feynman gate 2
    // --------------------------------------------------------

    feynman_gate fg2 (
        .A(dff2_q),
        .B(1'b0),
        .P(fg2_out),
        .Q()
    );

    // --------------------------------------------------------
    // Third reversible D flip-flop
    // --------------------------------------------------------

    reversible_dff dff3 (
        .clk(clk),
        .d(fg2_out),
        .q(dff3_q)
    );

    assign q2 = dff3_q;

    // --------------------------------------------------------
    // Feynman gate 3
    // --------------------------------------------------------

    feynman_gate fg3 (
        .A(dff3_q),
        .B(1'b0),
        .P(fg3_out),
        .Q()
    );

    // --------------------------------------------------------
    // Fourth reversible D flip-flop
    // --------------------------------------------------------

    reversible_dff dff4 (
        .clk(clk),
        .d(fg3_out),
        .q(dff4_q)
    );

    assign q3 = dff4_q;

    // --------------------------------------------------------
    // Parallel output
    // --------------------------------------------------------

    assign parallel_out = {q3, q2, q1, q0};

endmodule

