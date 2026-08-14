`timescale 1ns/1ps

// ============================================================
// Testbench for Sayem Reversible Gate
// Exhaustively tests all 16 possible 4-bit input combinations
// and checks that the outputs are unique (reversibility).
// ============================================================

module sayem_gate_tb;

    reg A;
    reg B;
    reg C;
    reg D;

    wire P;
    wire Q;
    wire R;
    wire S;

    reg [3:0] input_vector;
    reg [3:0] output_vector;
    reg [15:0] seen_outputs;

    integer i;
    integer errors;

    // Device under test
    sayem_gate dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .P(P),
        .Q(Q),
        .R(R),
        .S(S)
    );

    initial begin
        errors = 0;
        seen_outputs = 16'b0;

        $display("========================================");
        $display("SAYEM REVERSIBLE GATE TESTBENCH");
        $display("========================================");

        // Exhaustively test all 16 input combinations
        for (i = 0; i < 16; i = i + 1) begin

            input_vector = i[3:0];

            A = input_vector[3];
            B = input_vector[2];
            C = input_vector[1];
            D = input_vector[0];

            #1;

            output_vector = {P, Q, R, S};

            $display(
                "Input = %b%b%b%b  ->  Output = %b%b%b%b",
                A, B, C, D,
                P, Q, R, S
            );

            // Check that no two different inputs
            // produce the same output.
            if (seen_outputs[output_vector] == 1'b1) begin
                $display("ERROR: Duplicate output detected: %b", output_vector);
                errors = errors + 1;
            end

            seen_outputs[output_vector] = 1'b1;
        end

        $display("----------------------------------------");

        if (errors == 0) begin
            $display("PASS: All 16 input combinations produce");
            $display("      unique output combinations.");
            $display("PASS: Sayem gate is reversible.");
        end
        else begin
            $display("FAIL: %0d errors detected.", errors);
        end

        $display("========================================");
        $display("SAYEM GATE TEST COMPLETE");
        $display("========================================");

        $finish;
    end

endmodule