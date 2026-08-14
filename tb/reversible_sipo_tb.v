 `timescale 1ns/1ps

// ============================================================
// Testbench for 4-bit Reversible SIPO Shift Register
// ============================================================

module reversible_sipo_tb;

    reg clk;
    reg serial_in;

    wire [3:0] parallel_out;
    wire q0;
    wire q1;
    wire q2;
    wire q3;

    integer errors;

    reversible_sipo dut (
        .clk(clk),
        .serial_in(serial_in),
        .parallel_out(parallel_out),
        .q0(q0),
        .q1(q1),
        .q2(q2),
        .q3(q3)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin

        errors = 0;

        clk       = 0;
        serial_in = 0;

        // Initialize all DFF storage elements
        dut.dff1.master_latch.q = 0;
        dut.dff1.slave_latch.q  = 0;

        dut.dff2.master_latch.q = 0;
        dut.dff2.slave_latch.q  = 0;

        dut.dff3.master_latch.q = 0;
        dut.dff3.slave_latch.q  = 0;

        dut.dff4.master_latch.q = 0;
        dut.dff4.slave_latch.q  = 0;

        $display("========================================");
        $display("REVERSIBLE 4-BIT SIPO TESTBENCH");
        $display("========================================");

        #2;

        // ----------------------------------------------------
        // Initial state
        // ----------------------------------------------------

        if (parallel_out !== 4'b0000) begin
            $display(
                "FAIL: Initial output=%b (expected 0000)",
                parallel_out
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Initial output=0000");
        end

        // ----------------------------------------------------
        // Clock 1
        // Input = 1
        // ----------------------------------------------------

        serial_in = 1;

        @(posedge clk);
        #2;

        if (parallel_out !== 4'b0001) begin
            $display(
                "FAIL: Clock 1 output=%b (expected 0001)",
                parallel_out
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Clock 1 output=0001");
        end

        // ----------------------------------------------------
        // Clock 2
        // Input = 0
        // ----------------------------------------------------

        serial_in = 0;

        @(posedge clk);
        #2;

        if (parallel_out !== 4'b0010) begin
            $display(
                "FAIL: Clock 2 output=%b (expected 0010)",
                parallel_out
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Clock 2 output=0010");
        end

        // ----------------------------------------------------
        // Clock 3
        // ----------------------------------------------------

        @(posedge clk);
        #2;

        if (parallel_out !== 4'b0100) begin
            $display(
                "FAIL: Clock 3 output=%b (expected 0100)",
                parallel_out
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Clock 3 output=0100");
        end

        // ----------------------------------------------------
        // Clock 4
        // ----------------------------------------------------

        @(posedge clk);
        #2;

        if (parallel_out !== 4'b1000) begin
            $display(
                "FAIL: Clock 4 output=%b (expected 1000)",
                parallel_out
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Clock 4 output=1000");
        end

        // ----------------------------------------------------
        // Clock 5
        // Zero shifts through the register
        // ----------------------------------------------------

        @(posedge clk);
        #2;

        if (parallel_out !== 4'b0000) begin
            $display(
                "FAIL: Clock 5 output=%b (expected 0000)",
                parallel_out
            );
            errors = errors + 1;
        end
        else begin
            $display("PASS: Clock 5 output=0000");
        end

        $display("----------------------------------------");

        if (errors == 0) begin
            $display("PASS: All SIPO shift tests passed.");
        end
        else begin
            $display("FAIL: %0d errors detected.", errors);
        end

        $display("========================================");
        $display("SIPO TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule

