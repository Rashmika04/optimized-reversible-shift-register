`timescale 1ns/1ps

// ============================================================
// Testbench for Reversible D Latch
// ============================================================

module reversible_d_latch_tb;

    reg clk;
    reg d;
    wire q;

    integer errors;

    // Device Under Test
    reversible_d_latch dut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    initial begin

        errors = 0;

        clk = 0;
        d   = 0;

        // Initialize the latch state
        dut.q = 0;

        $display("========================================");
        $display("REVERSIBLE D LATCH TESTBENCH");
        $display("========================================");

        // ----------------------------------------------------
        // Test 1: CLK=0, Q should retain 0
        // ----------------------------------------------------

        #5;

        if (q !== 0) begin
            $display("FAIL: CLK=0 D=0 -> Q=%b (expected 0)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: CLK=0 D=0 -> Q=0");
        end

        // ----------------------------------------------------
        // Test 2: CLK=1, D=1 -> Q should become 1
        // ----------------------------------------------------

        clk = 1;
        d   = 1;

        #5;

        if (q !== 1) begin
            $display("FAIL: CLK=1 D=1 -> Q=%b (expected 1)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: CLK=1 D=1 -> Q=1");
        end

        // ----------------------------------------------------
        // Test 3: CLK=1, D=0 -> Q should become 0
        // ----------------------------------------------------

        d = 0;

        #5;

        if (q !== 0) begin
            $display("FAIL: CLK=1 D=0 -> Q=%b (expected 0)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: CLK=1 D=0 -> Q=0");
        end

        // ----------------------------------------------------
        // Test 4: CLK=0, D=1
        // Q should HOLD previous value 0
        // ----------------------------------------------------

        clk = 0;
        d   = 1;

        #5;

        if (q !== 0) begin
            $display("FAIL: CLK=0 D=1 -> Q=%b (expected 0)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: CLK=0 D=1 -> Q holds 0");
        end

        // ----------------------------------------------------
        // Test 5: CLK=1, D=1 -> Q becomes 1
        // ----------------------------------------------------

        clk = 1;

        #5;

        if (q !== 1) begin
            $display("FAIL: CLK=1 D=1 -> Q=%b (expected 1)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: CLK=1 D=1 -> Q=1");
        end

        // ----------------------------------------------------
        // Test 6: CLK=0, D=0
        // Q should HOLD previous value 1
        // ----------------------------------------------------

        clk = 0;
        d   = 0;

        #5;

        if (q !== 1) begin
            $display("FAIL: CLK=0 D=0 -> Q=%b (expected 1)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: CLK=0 D=0 -> Q holds 1");
        end

        // ----------------------------------------------------

        $display("----------------------------------------");

        if (errors == 0) begin
            $display("PASS: All D latch tests passed.");
        end
        else begin
            $display("FAIL: %0d errors detected.", errors);
        end

        $display("========================================");
        $display("D LATCH TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule
