`timescale 1ns/1ps

module pc32_tb;

    logic clk;
    logic rst;

    logic [31:0] i_pc_next;
    logic [31:0] o_pc;

    pc32 dut (
        .clk    (clk),
        .rst    (rst),
        .i_pc_next (i_pc_next),
        .o_pc   (o_pc)
    );

    always begin
        #5 clk = ~clk;
    end

    task automatic check_register(
        input logic [31:0] addr,
        input logic [31:0] addr_expected
    );

        begin

            @(negedge clk);

            i_pc_next = addr;

            @(posedge clk);
            #1

            if (o_pc !== addr_expected) begin
                $error(
                    "FAIL PC: Address=%0d Expected=%h Got=%h",
                    addr,
                    addr_expected,
                    o_pc
                );
            end

            else begin
                $display(
                    "PASS PC: Address=%0d Data=%h",
                    addr,
                    o_pc
                );
            end
        end
    endtask

    // Test sequence
    initial begin

        // -------------------------
        // Initialize signals
        // -------------------------

        clk       = 1'b0;
        rst       = 1'b0;
        i_pc_next = 32'd0;


        // -------------------------
        // Reset test
        // -------------------------

        #1;

        if (o_pc !== 32'd0) begin

            $error(
                "FAIL RESET: Expected PC=00000000 Got=%h",
                o_pc
            );

        end
        else begin

            $display(
                "PASS RESET: PC=%h",
                o_pc
            );

        end


        // Release reset
        #5;
        rst = 1'b1;


        // -------------------------
        // Basic PC update
        // -------------------------

        check_register(
            32'h0000_0004,
            32'h0000_0004
        );


        // -------------------------
        // Sequential PC increment
        // -------------------------

        check_register(
            32'h0000_0008,
            32'h0000_0008
        );

        check_register(
            32'h0000_000C,
            32'h0000_000C
        );


        // -------------------------
        // Branch target example
        // -------------------------

        check_register(
            32'h0000_0100,
            32'h0000_0100
        );


        // -------------------------
        // Jump target example
        // -------------------------

        check_register(
            32'h0000_1000,
            32'h0000_1000
        );


        // -------------------------
        // Arbitrary PC address
        // -------------------------

        check_register(
            32'hDEAD_BEEF,
            32'hDEAD_BEEF
        );


        // -------------------------
        // Reset after updates
        // -------------------------

        rst = 1'b0;

        #1;

        if (o_pc !== 32'd0) begin

            $error(
                "FAIL RESET AFTER UPDATE: Expected=%h Got=%h",
                32'd0,
                o_pc
            );

        end
        else begin

            $display(
                "PASS RESET AFTER UPDATE: PC=%h",
                o_pc
            );

        end


        // -------------------------
        // Complete simulation
        // -------------------------

        $display("------------------------------");
        $display("ALL PC TESTS COMPLETED");
        $display("------------------------------");

        $finish;

    end

endmodule