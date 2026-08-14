// ============================================================
// 4-bit Reversible Universal Shift Register
//
// Proposed design based on:
// "Optimized Shift Register Design Using Reversible Logic"
//
// Four reversible D flip-flops are used.
// Each DFF receives its input through a 4-to-1 selection stage.
//
// Select lines:
//
// S1 S0
// -----
// 0  0  -> Hold
// 0  1  -> Shift right
// 1  0  -> Shift left
// 1  1  -> Parallel load
//
// Parallel outputs are available from q[3:0].
//
// Bit orientation:
//
// q[3] = leftmost stage
// q[0] = rightmost stage
//
// Shift right:
// q[3] <- serial_right
// q[2] <- q[3]
// q[1] <- q[2]
// q[0] <- q[1]
//
// Shift left:
// q[3] <- q[2]
// q[2] <- q[1]
// q[1] <- q[0]
// q[0] <- serial_left
// ============================================================


// ============================================================
// 4-to-1 Multiplexer
//
// Select:
//
// S1 S0 = 00 -> I0
// S1 S0 = 01 -> I1
// S1 S0 = 10 -> I2
// S1 S0 = 11 -> I3
// ============================================================

module mux4to1 (
    input I0,
    input I1,
    input I2,
    input I3,

    input S1,
    input S0,

    output Y
);

    assign Y =
        (~S1 & ~S0 & I0) |
        (~S1 &  S0 & I1) |
        ( S1 & ~S0 & I2) |
        ( S1 &  S0 & I3);

endmodule


// ============================================================
// 4-bit Reversible Universal Shift Register
// ============================================================

module reversible_universal_shift_register (

    input clk,

    // Select lines
    input S1,
    input S0,

    // Parallel input
    input [3:0] parallel_in,

    // Serial inputs
    input serial_right,
    input serial_left,

    // Parallel output
    output wire [3:0] q

);

    // --------------------------------------------------------
    // D inputs for the four reversible D flip-flops
    // --------------------------------------------------------

    wire d0;
    wire d1;
    wire d2;
    wire d3;

    // --------------------------------------------------------
    // 4-to-1 selection for q[0]
    //
    // 00 -> hold q[0]
    // 01 -> shift right: q[1]
    // 10 -> shift left: serial_left
    // 11 -> parallel load: parallel_in[0]
    // --------------------------------------------------------

    mux4to1 mux0 (
        .I0(q[0]),
        .I1(q[1]),
        .I2(serial_left),
        .I3(parallel_in[0]),

        .S1(S1),
        .S0(S0),

        .Y(d0)
    );

    // --------------------------------------------------------
    // 4-to-1 selection for q[1]
    //
    // 00 -> hold q[1]
    // 01 -> shift right: q[2]
    // 10 -> shift left: q[0]
    // 11 -> parallel load: parallel_in[1]
    // --------------------------------------------------------

    mux4to1 mux1 (
        .I0(q[1]),
        .I1(q[2]),
        .I2(q[0]),
        .I3(parallel_in[1]),

        .S1(S1),
        .S0(S0),

        .Y(d1)
    );

    // --------------------------------------------------------
    // 4-to-1 selection for q[2]
    //
    // 00 -> hold q[2]
    // 01 -> shift right: q[3]
    // 10 -> shift left: q[1]
    // 11 -> parallel load: parallel_in[2]
    // --------------------------------------------------------

    mux4to1 mux2 (
        .I0(q[2]),
        .I1(q[3]),
        .I2(q[1]),
        .I3(parallel_in[2]),

        .S1(S1),
        .S0(S0),

        .Y(d2)
    );

    // --------------------------------------------------------
    // 4-to-1 selection for q[3]
    //
    // 00 -> hold q[3]
    // 01 -> shift right: serial_right
    // 10 -> shift left: q[2]
    // 11 -> parallel load: parallel_in[3]
    // --------------------------------------------------------

    mux4to1 mux3 (
        .I0(q[3]),
        .I1(serial_right),
        .I2(q[2]),
        .I3(parallel_in[3]),

        .S1(S1),
        .S0(S0),

        .Y(d3)
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

endmodule

