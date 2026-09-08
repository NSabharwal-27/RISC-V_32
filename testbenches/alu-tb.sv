`timescale 1ns/1ps

import alu_states_pkg::*;

module alu_tb;

    // DUT inputs
    logic [31:0] i_data1;
    logic [31:0] i_data2;
    logic [3:0]  i_alusel;

    // DUT output
    logic [31:0] o_data;

    // Expected result
    logic [31:0] expected;


    // DUT instantiation
    alu dut (
        .i_data1  (i_data1),
        .i_data2  (i_data2),
        .i_alusel (i_alusel),
        .o_data   (o_data)
    );


    // Task to apply inputs and verify output
    task automatic check(
        input logic [31:0] test_i_data1,
        input logic [31:0] test_i_data2,
        input logic [3:0]  test_i_alusel
    );

        begin

            // Apply inputs
            i_data1  = test_i_data1;
            i_data2  = test_i_data2;
            i_alusel = test_i_alusel;


            // Calculate expected result
            case (test_i_alusel)

                ALU_ADD:
                    expected = test_i_data1 + test_i_data2;

                ALU_SUB:
                    expected = test_i_data1 - test_i_data2;

                ALU_AND:
                    expected = test_i_data1 & test_i_data2;

                ALU_OR:
                    expected = test_i_data1 | test_i_data2;

                ALU_XOR:
                    expected = test_i_data1 ^ test_i_data2;

                ALU_SLT:
                    expected =
                        ($signed(test_i_data1) < $signed(test_i_data2))
                        ? 32'd1 : 32'd0;

                ALU_SLTU:
                    expected =
                        (test_i_data1 < test_i_data2)
                        ? 32'd1 : 32'd0;

                ALU_SLL:
                    expected =
                        test_i_data1 << test_i_data2[4:0];

                ALU_SRL:
                    expected =
                        test_i_data1 >> test_i_data2[4:0];

                ALU_SRA:
                    expected =
                        $signed(test_i_data1) >>> test_i_data2[4:0];

                default:
                    expected = 32'd0;

            endcase


            // Allow combinational logic to settle
            #1;


            // Compare output with expected result
            if (o_data !== expected) begin

                $error(
                    "FAIL: A=%h B=%h ALU_SEL=%h | Expected=%h Got=%h",
                    test_i_data1,
                    test_i_data2,
                    test_i_alusel,
                    expected,
                    o_data
                );

            end
            else begin

                $display(
                    "PASS: A=%h B=%h ALU_SEL=%h | Result=%h",
                    test_i_data1,
                    test_i_data2,
                    test_i_alusel,
                    o_data
                );

            end

        end

    endtask


    initial begin

        // Initialize inputs
        i_data1  = 32'd0;
        i_data2  = 32'd0;
        i_alusel = ALU_ADD;


        // -------------------------
        // ADD tests
        // -------------------------
        check(32'd10, 32'd20, ALU_ADD);
        check(32'hFFFF_FFFF, 32'd1, ALU_ADD);


        // -------------------------
        // SUB tests
        // -------------------------
        check(32'd30, 32'd10, ALU_SUB);
        check(32'd10, 32'd20, ALU_SUB);


        // -------------------------
        // AND tests
        // -------------------------
        check(32'hFFFF_0000, 32'h0F0F_0F0F, ALU_AND);


        // -------------------------
        // OR tests
        // -------------------------
        check(32'hF000_0000, 32'h0F00_0000, ALU_OR);


        // -------------------------
        // XOR tests
        // -------------------------
        check(32'hAAAA_AAAA, 32'h5555_5555, ALU_XOR);


        // -------------------------
        // SLT tests (signed)
        // -------------------------

        // -5 < 3 should be true
        check(32'hFFFF_FFFB, 32'd3, ALU_SLT);

        // 10 < -5 should be false
        check(32'd10, 32'hFFFF_FFFB, ALU_SLT);


        // -------------------------
        // SLTU tests (unsigned)
        // -------------------------

        check(32'd5, 32'd10, ALU_SLTU);

        // 0xFFFFFFFF is larger than 1 unsigned
        check(32'hFFFF_FFFF, 32'd1, ALU_SLTU);


        // -------------------------
        // SLL tests
        // -------------------------

        check(32'd1, 32'd4, ALU_SLL);

        // Tests lower 5-bit shift amount
        check(32'd1, 32'd36, ALU_SLL);


        // -------------------------
        // SRL tests
        // -------------------------

        check(32'h8000_0000, 32'd4, ALU_SRL);


        // -------------------------
        // SRA tests
        // -------------------------

        // Arithmetic shift should preserve sign bit
        check(32'h8000_0000, 32'd4, ALU_SRA);


        $display("------------------------------");
        $display("All ALU tests completed.");
        $display("------------------------------");

        $finish;

    end

endmodule