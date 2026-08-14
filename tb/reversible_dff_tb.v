`timescale 1ns/1ps

// ============================================================
// Testbench for Proposed Reversible D Flip-Flop
//
// The DFF is implemented as a master-slave arrangement of
// two reversible D latches.
// ============================================================

module reversible_dff_tb;

    reg clk;
    reg d;
    wire q;

    integer errors;

    // Device Under Test
    reversible_dff dut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    initial begin

        errors = 0;

        clk = 0;
        d   = 0;
        dut.master_latch.q = 1'b0;
        dut.slave_latch.q  = 1'b0;

        $display("========================================");
        $display("REVERSIBLE D FLIP-FLOP TESTBENCH");
        $display("========================================");

        // ----------------------------------------------------
        // Initial condition
        // ----------------------------------------------------

        #5;

        if (q !== 0) begin
            $display("FAIL: Initial Q=%b (expected 0)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Initial Q=0");
        end

        // ----------------------------------------------------
        // D=0
        // At the positive edge Q should become 0
        // ----------------------------------------------------

        d = 0;

        #5;
        clk = 1;
        #5;

        if (q !== 0) begin
            $display("FAIL: D=0 -> Q=%b (expected 0)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: D=0 -> Q=0");
        end

        clk = 0;
        #5;

        // ----------------------------------------------------
        // D=1
        // At the positive edge Q should become 1
        // ----------------------------------------------------

        d = 1;

        #5;
        clk = 1;
        #5;

        if (q !== 1) begin
            $display("FAIL: D=1 -> Q=%b (expected 1)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: D=1 -> Q=1");
        end

        clk = 0;
        #5;

        // ----------------------------------------------------
        // Change D while clock is low.
        // Q should remain unchanged until the next edge.
        // ----------------------------------------------------

        d = 0;

        #5;

        if (q !== 1) begin
            $display(
                "FAIL: D changed while CLK=0 -> Q=%b (expected 1)",
                q
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Q holds 1 while CLK=0");
        end

        // ----------------------------------------------------
        // Next positive edge with D=0
        // Q should become 0
        // ----------------------------------------------------

        #5;
        clk = 1;
        #5;

        if (q !== 0) begin
            $display("FAIL: Next edge D=0 -> Q=%b (expected 0)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Next edge D=0 -> Q=0");
        end

        clk = 0;
        #5;

        // ----------------------------------------------------
        // Final D=1 test
        // ----------------------------------------------------

        d = 1;

        #5;
        clk = 1;
        #5;

        if (q !== 1) begin
            $display("FAIL: Final D=1 -> Q=%b (expected 1)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Final D=1 -> Q=1");
        end

        $display("----------------------------------------");

        if (errors == 0) begin
            $display("PASS: Reversible D flip-flop verified.");
            $display("PASS: Master-slave operation is correct.");
        end
        else begin
            $display("FAIL: %0d errors detected.", errors);
        end

        $display("========================================");
        $display("D FLIP-FLOP TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule
