`timescale 1ns/1ps

// ============================================================
// Testbench for 4-bit Reversible Universal Shift Register
//
// Select lines:
//
// S1 S0
//  0  0  -> Hold
//  0  1  -> Shift right
//  1  0  -> Shift left
//  1  1  -> Parallel load
//
// Test sequence:
//
// 1. Parallel load 1011
// 2. Hold
// 3. Shift right
// 4. Shift right
// 5. Shift left
// 6. Shift left
// ============================================================

module reversible_universal_shift_register_tb;

    reg clk;

    reg S1;
    reg S0;

    reg [3:0] parallel_in;

    reg serial_right;
    reg serial_left;

    wire [3:0] q;

    integer errors;


    // ========================================================
    // Device Under Test
    // ========================================================

    reversible_universal_shift_register dut (

        .clk(clk),

        .S1(S1),
        .S0(S0),

        .parallel_in(parallel_in),

        .serial_right(serial_right),
        .serial_left(serial_left),

        .q(q)

    );


    // ========================================================
    // Clock
    // ========================================================

    always #5 clk = ~clk;


    // ========================================================
    // Test
    // ========================================================

    initial begin
           $dumpfile("simulation/universal_shift_register.vcd");
           $dumpvars(0, reversible_universal_shift_register_tb);

        errors = 0;
         
        clk = 0;

        S1 = 0;
        S0 = 0;

        parallel_in = 4'b0000;

        serial_right = 0;
        serial_left = 0;


        // ----------------------------------------------------
        // Initialize DFF storage
        // ----------------------------------------------------

        dut.dff0.master_latch.q = 0;
        dut.dff0.slave_latch.q  = 0;

        dut.dff1.master_latch.q = 0;
        dut.dff1.slave_latch.q  = 0;

        dut.dff2.master_latch.q = 0;
        dut.dff2.slave_latch.q  = 0;

        dut.dff3.master_latch.q = 0;
        dut.dff3.slave_latch.q  = 0;


        $display("========================================");
        $display("REVERSIBLE 4-BIT UNIVERSAL SHIFT REGISTER");
        $display("========================================");


        #2;


        // ====================================================
        // TEST 1 — INITIAL STATE
        // ====================================================

        if (q !== 4'b0000) begin

            $display(
                "FAIL: Initial Q=%b (expected 0000)",
                q
            );

            errors = errors + 1;

        end
        else begin

            $display("PASS: Initial Q=0000");

        end


        // ====================================================
        // TEST 2 — PARALLEL LOAD
        //
        // S1 S0 = 11
        //
        // Load 1011
        // ====================================================

        S1 = 1;
        S0 = 1;

        parallel_in = 4'b1011;

        @(posedge clk);
        #2;


        if (q !== 4'b1011) begin

            $display(
                "FAIL: Parallel load Q=%b (expected 1011)",
                q
            );

            errors = errors + 1;

        end
        else begin

            $display("PASS: Parallel load Q=1011");

        end


        // ====================================================
        // TEST 3 — HOLD
        //
        // S1 S0 = 00
        //
        // Q should remain 1011
        // ====================================================

        S1 = 0;
        S0 = 0;

        @(posedge clk);
        #2;


        if (q !== 4'b1011) begin

            $display(
                "FAIL: Hold Q=%b (expected 1011)",
                q
            );

            errors = errors + 1;

        end
        else begin

            $display("PASS: Hold Q=1011");

        end


        // ====================================================
        // TEST 4 — SHIFT RIGHT
        //
        // S1 S0 = 01
        //
        // 1011 -> 0101
        //
        // serial_right = 0
        // ====================================================

        S1 = 0;
        S0 = 1;

        serial_right = 0;

        @(posedge clk);
        #2;


        if (q !== 4'b0101) begin

            $display(
                "FAIL: Shift right 1 Q=%b (expected 0101)",
                q
            );

            errors = errors + 1;

        end
        else begin

            $display("PASS: Shift right 1 Q=0101");

        end


        // ====================================================
        // TEST 5 — SHIFT RIGHT AGAIN
        //
        // 0101 -> 0010
        // ====================================================

        @(posedge clk);
        #2;


        if (q !== 4'b0010) begin

            $display(
                "FAIL: Shift right 2 Q=%b (expected 0010)",
                q
            );

            errors = errors + 1;

        end
        else begin

            $display("PASS: Shift right 2 Q=0010");

        end


        // ====================================================
        // TEST 6 — SHIFT LEFT
        //
        // S1 S0 = 10
        //
        // 0010 -> 0100
        //
        // serial_left = 0
        // ====================================================

        S1 = 1;
        S0 = 0;

        serial_left = 0;

        @(posedge clk);
        #2;


        if (q !== 4'b0100) begin

            $display(
                "FAIL: Shift left 1 Q=%b (expected 0100)",
                q
            );

            errors = errors + 1;

        end
        else begin

            $display("PASS: Shift left 1 Q=0100");

        end


        // ====================================================
        // TEST 7 — SHIFT LEFT AGAIN
        //
        // 0100 -> 1000
        // ====================================================

        @(posedge clk);
        #2;


        if (q !== 4'b1000) begin

            $display(
                "FAIL: Shift left 2 Q=%b (expected 1000)",
                q
            );

            errors = errors + 1;

        end
        else begin

            $display("PASS: Shift left 2 Q=1000");

        end


        // ====================================================
        // FINAL RESULT
        // ====================================================

        $display("----------------------------------------");


        if (errors == 0) begin

            $display(
                "PASS: All Universal Shift Register tests passed."
            );

            $display(
                "PASS: Hold, parallel load, shift right, and shift left verified."
            );

        end
        else begin

            $display(
                "FAIL: %0d errors detected.",
                errors
            );

        end


        $display("========================================");
        $display("UNIVERSAL SHIFT REGISTER TEST COMPLETE");
        $display("========================================");


        $finish;

    end

endmodule

