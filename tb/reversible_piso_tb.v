`timescale 1ns/1ps

// ============================================================
// Testbench for 4-bit Reversible PISO Shift Register
//
// E = 1 -> Parallel load
// E = 0 -> Shift right
//
// Test pattern:
// Parallel input = 1011
//
// After loading:
// Q = 1011
//
// Then shifting with serial_in = 0:
//
// 1011 -> 0110 -> 1100 -> 1000 -> 0000
//
// Serial output is q[3].
// ============================================================

module reversible_piso_tb;

    reg clk;
    reg enable;
    reg serial_in;
    reg [3:0] parallel_in;

    wire serial_out;
    wire [3:0] q;

    integer errors;

    reversible_piso dut (
        .clk(clk),
        .enable(enable),
        .parallel_in(parallel_in),
        .serial_in(serial_in),
        .serial_out(serial_out),
        .q(q)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        errors = 0;

        clk         = 0;
        enable      = 0;
        serial_in   = 0;
        parallel_in = 4'b0000;

        // Initialize all DFF storage elements
        dut.dff0.master_latch.q = 0;
        dut.dff0.slave_latch.q  = 0;

        dut.dff1.master_latch.q = 0;
        dut.dff1.slave_latch.q  = 0;

        dut.dff2.master_latch.q = 0;
        dut.dff2.slave_latch.q  = 0;

        dut.dff3.master_latch.q = 0;
        dut.dff3.slave_latch.q  = 0;

        $display("========================================");
        $display("REVERSIBLE 4-BIT PISO TESTBENCH");
        $display("========================================");

        #2;

        // ----------------------------------------------------
        // Initial state
        // ----------------------------------------------------

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

        // ----------------------------------------------------
        // PARALLEL LOAD
        //
        // Enable = 1
        // Parallel input = 1011
        // ----------------------------------------------------

        enable      = 1;
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

        // ----------------------------------------------------
        // SHIFT 1
        //
        // 1011 -> 0110
        // ----------------------------------------------------

        enable   = 0;
        serial_in = 0;

        @(posedge clk);
        #2;

        if (q !== 4'b0110) begin
            $display(
                "FAIL: Shift 1 Q=%b (expected 0110)",
                q
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Shift 1 Q=0110");
        end

        // ----------------------------------------------------
        // SHIFT 2
        //
        // 0110 -> 1100
        // ----------------------------------------------------

        @(posedge clk);
        #2;

        if (q !== 4'b1100) begin
            $display(
                "FAIL: Shift 2 Q=%b (expected 1100)",
                q
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Shift 2 Q=1100");
        end

        // ----------------------------------------------------
        // SHIFT 3
        //
        // 1100 -> 1000
        // ----------------------------------------------------

        @(posedge clk);
        #2;

        if (q !== 4'b1000) begin
            $display(
                "FAIL: Shift 3 Q=%b (expected 1000)",
                q
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Shift 3 Q=1000");
        end

        // ----------------------------------------------------
        // SHIFT 4
        //
        // 1000 -> 0000
        // ----------------------------------------------------

        @(posedge clk);
        #2;

        if (q !== 4'b0000) begin
            $display(
                "FAIL: Shift 4 Q=%b (expected 0000)",
                q
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Shift 4 Q=0000");
        end

        // ----------------------------------------------------

        $display("----------------------------------------");

        if (errors == 0) begin
            $display("PASS: All PISO tests passed.");
        end
        else begin
            $display("FAIL: %0d errors detected.", errors);
        end

        $display("========================================");
        $display("PISO TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule

