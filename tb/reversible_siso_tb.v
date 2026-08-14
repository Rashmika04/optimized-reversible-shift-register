`timescale 1ns/1ps

// ============================================================
// Testbench for 4-bit Reversible SISO Shift Register
//
// Expected sequence:
//
// Initial : 0000
// Clock 1 : 0001
// Clock 2 : 0010
// Clock 3 : 0100
// Clock 4 : 1000
// Clock 5 : 0000
//
// q[3] is the serial output.
// ============================================================

module reversible_siso_tb;

    reg clk;
    reg serial_in;

    wire serial_out;
    wire [3:0] q;

    integer errors;

    reversible_siso dut (
        .clk(clk),
        .serial_in(serial_in),
        .serial_out(serial_out),
        .q(q)
    );

    // --------------------------------------------------------
    // Clock generation
    // --------------------------------------------------------

    always #5 clk = ~clk;

    initial begin

        errors = 0;

        clk       = 0;
        serial_in = 0;

        // Initialize internal flip-flops
        dut.dff1.master_latch.q = 0;
        dut.dff1.slave_latch.q  = 0;

        dut.dff2.master_latch.q = 0;
        dut.dff2.slave_latch.q  = 0;

        dut.dff3.master_latch.q = 0;
        dut.dff3.slave_latch.q  = 0;

        dut.dff4.master_latch.q = 0;
        dut.dff4.slave_latch.q  = 0;

        $display("========================================");
        $display("REVERSIBLE 4-BIT SISO TESTBENCH");
        $display("========================================");

        #2;

        // ----------------------------------------------------
        // Initial state
        // ----------------------------------------------------

        if (q !== 4'b0000) begin
            $display("FAIL: Initial Q=%b (expected 0000)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Initial Q=0000");
        end

        // ----------------------------------------------------
        // Clock 1
        // Serial input = 1
        // ----------------------------------------------------

        serial_in = 1;

        @(posedge clk);
        #2;

        if (q !== 4'b0001) begin
            $display("FAIL: Clock 1 Q=%b (expected 0001)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Clock 1 Q=0001");
        end

        // ----------------------------------------------------
        // Clock 2
        // Serial input = 0
        // ----------------------------------------------------

        serial_in = 0;

        @(posedge clk);
        #2;

        if (q !== 4'b0010) begin
            $display("FAIL: Clock 2 Q=%b (expected 0010)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Clock 2 Q=0010");
        end

        // ----------------------------------------------------
        // Clock 3
        // ----------------------------------------------------

        @(posedge clk);
        #2;

        if (q !== 4'b0100) begin
            $display("FAIL: Clock 3 Q=%b (expected 0100)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Clock 3 Q=0100");
        end

        // ----------------------------------------------------
        // Clock 4
        // ----------------------------------------------------

        @(posedge clk);
        #2;

        if (q !== 4'b1000) begin
            $display("FAIL: Clock 4 Q=%b (expected 1000)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Clock 4 Q=1000");
        end

        // ----------------------------------------------------
        // Clock 5
        // Zero continues shifting through the register
        // ----------------------------------------------------

        @(posedge clk);
        #2;

        if (q !== 4'b0000) begin
            $display("FAIL: Clock 5 Q=%b (expected 0000)", q);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Clock 5 Q=0000");
        end

        // ----------------------------------------------------

        $display("----------------------------------------");

        if (errors == 0) begin
            $display("PASS: All SISO shift tests passed.");
        end
        else begin
            $display("FAIL: %0d errors detected.", errors);
        end

        $display("========================================");
        $display("SISO TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule

