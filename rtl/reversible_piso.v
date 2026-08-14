// ============================================================
// 4-bit Reversible PISO Shift Register
//
// Parallel-In Serial-Out
//
// E = 1 : Parallel load
// E = 0 : Shift right
//
// Structure:
//
//             ┌───────────────┐
// P0 ────────►│               │
// Shift0 ────►│  Fredkin #1   │──► DFF0
//             └───────────────┘
//
// P1 ────────►┐
// Q0 ────────►│  Fredkin #2   │──► DFF1
//
// P2 ────────►┐
// Q1 ────────►│  Fredkin #3   │──► DFF2
//
// P3 ────────►┐
// Q2 ────────►│  Fredkin #4   │──► DFF3
//                                      │
//                                      ▼
//                                  Serial Out
//
// Based on the proposed PISO architecture in the report.
// ============================================================


// ============================================================
// Fredkin Reversible Gate
//
// 3 x 3 reversible gate
//
// P = C
// Q = C' A + C B
// R = C' B + C A
//
// When C = 0:
//     Q = A
//     R = B
//
// When C = 1:
//     Q = B
//     R = A
//
// For this PISO:
//     C = Enable
//     A = shift data
//     B = parallel data
//
// Therefore:
//     Enable = 0 -> shift data selected
//     Enable = 1 -> parallel data selected
// ============================================================

module fredkin_gate (
    input C,
    input A,
    input B,
    output P,
    output Q,
    output R
);

    assign P = C;
    assign Q = (~C & A) | (C & B);
    assign R = (~C & B) | (C & A);

endmodule


// ============================================================
// 4-bit Reversible PISO Shift Register
// ============================================================

module reversible_piso (
    input clk,
    input enable,

    input [3:0] parallel_in,
    input serial_in,

    output wire serial_out,
    output wire [3:0] q
);

    // --------------------------------------------------------
    // Selected inputs to the four D flip-flops
    // --------------------------------------------------------

    wire d0;
    wire d1;
    wire d2;
    wire d3;

    // Unused Fredkin outputs
    wire f0_p;
    wire f0_r;

    wire f1_p;
    wire f1_r;

    wire f2_p;
    wire f2_r;

    wire f3_p;
    wire f3_r;

    // --------------------------------------------------------
    // Fredkin #1
    //
    // When enable = 1:
    //     d0 = parallel_in[0]
    //
    // When enable = 0:
    //     d0 = serial_in
    // --------------------------------------------------------

    fredkin_gate fg0 (
        .C(enable),
        .A(serial_in),
        .B(parallel_in[0]),
        .P(f0_p),
        .Q(d0),
        .R(f0_r)
    );

    // --------------------------------------------------------
    // Fredkin #2
    //
    // Shift source = q[0]
    // Parallel source = parallel_in[1]
    // --------------------------------------------------------

    fredkin_gate fg1 (
        .C(enable),
        .A(q[0]),
        .B(parallel_in[1]),
        .P(f1_p),
        .Q(d1),
        .R(f1_r)
    );

    // --------------------------------------------------------
    // Fredkin #3
    // --------------------------------------------------------

    fredkin_gate fg2 (
        .C(enable),
        .A(q[1]),
        .B(parallel_in[2]),
        .P(f2_p),
        .Q(d2),
        .R(f2_r)
    );

    // --------------------------------------------------------
    // Fredkin #4
    // --------------------------------------------------------

    fredkin_gate fg3 (
        .C(enable),
        .A(q[2]),
        .B(parallel_in[3]),
        .P(f3_p),
        .Q(d3),
        .R(f3_r)
    );

    // --------------------------------------------------------
    // Four reversible D flip-flops
    // --------------------------------------------------------

    reversible_dff dff0 (
        .clk(clk),
        .d(d0),
        .q(q[0])
    );

    reversible_dff dff1 (
        .clk(clk),
        .d(d1),
        .q(q[1])
    );

    reversible_dff dff2 (
        .clk(clk),
        .d(d2),
        .q(q[2])
    );

    reversible_dff dff3 (
        .clk(clk),
        .d(d3),
        .q(q[3])
    );

    // Rightmost flip-flop is the serial output
    assign serial_out = q[3];

endmodule

