`timescale 1ns/1ps

module register_file_tb;

    // Clock and reset
    logic clk;
    logic rst;

    // Write interface
    logic        i_we;
    logic [31:0] i_rd_data;
    logic [4:0]  i_rd_addr;

    // Read addresses
    logic [4:0] i_rs1_addr;
    logic [4:0] i_rs2_addr;

    // Read data
    logic [31:0] o_rs1;
    logic [31:0] o_rs2;


    // DUT instantiation
    register_file dut (
        .clk         (clk),
        .rst         (rst),
        .i_we        (i_we),
        .i_rd_data   (i_rd_data),
        .i_rd_addr   (i_rd_addr),
        .i_rs1_addr  (i_rs1_addr),
        .i_rs2_addr  (i_rs2_addr),
        .o_rs1       (o_rs1),
        .o_rs2       (o_rs2)
    );


    // Clock generation
    always begin
        #5 clk = ~clk;
    end


    // -----------------------------------------
    // Task: Write to a register
    // -----------------------------------------
    task automatic write_register(
        input logic [4:0]  addr,
        input logic [31:0] data
    );

        begin

            // Set write signals
            i_we      = 1'b1;
            i_rd_addr = addr;
            i_rd_data = data;

            // Wait for positive clock edge
            @(posedge clk);

            // Disable write
            #1;
            i_we = 1'b0;

        end

    endtask


    // -----------------------------------------
    // Task: Read and verify registers
    // -----------------------------------------
    task automatic check_register(
        input logic [4:0]  rs1_addr,
        input logic [4:0]  rs2_addr,
        input logic [31:0] expected_rs1,
        input logic [31:0] expected_rs2
    );

        begin

            // Set read addresses
            i_rs1_addr = rs1_addr;
            i_rs2_addr = rs2_addr;

            // Allow combinational reads to settle
            #1;

            // Check rs1
            if (o_rs1 !== expected_rs1) begin

                $error(
                    "FAIL RS1: Address=%0d Expected=%h Got=%h",
                    rs1_addr,
                    expected_rs1,
                    o_rs1
                );

            end
            else begin

                $display(
                    "PASS RS1: Address=%0d Data=%h",
                    rs1_addr,
                    o_rs1
                );

            end


            // Check rs2
            if (o_rs2 !== expected_rs2) begin

                $error(
                    "FAIL RS2: Address=%0d Expected=%h Got=%h",
                    rs2_addr,
                    expected_rs2,
                    o_rs2
                );

            end
            else begin

                $display(
                    "PASS RS2: Address=%0d Data=%h",
                    rs2_addr,
                    o_rs2
                );

            end

        end

    endtask


    // -----------------------------------------
    // Test sequence
    // -----------------------------------------
    initial begin

        // Initialize signals
        clk        = 1'b0;
        rst        = 1'b0;

        i_we       = 1'b0;
        i_rd_data  = 32'd0;
        i_rd_addr  = 5'd0;

        i_rs1_addr = 5'd0;
        i_rs2_addr = 5'd0;


        // -------------------------------------
        // Reset test
        // -------------------------------------

        #10;

        rst = 1'b1;

        #10;


        // -------------------------------------
        // Test x0 is always zero
        // -------------------------------------

        check_register(
            5'd0,
            5'd0,
            32'd0,
            32'd0
        );


        // Try writing to x0
        write_register(
            5'd0,
            32'hDEAD_BEEF
        );

        // x0 must still be zero
        check_register(
            5'd0,
            5'd0,
            32'd0,
            32'd0
        );


        // -------------------------------------
        // Write and read x1
        // -------------------------------------

        write_register(
            5'd1,
            32'h1234_5678
        );

        check_register(
            5'd1,
            5'd0,
            32'h1234_5678,
            32'd0
        );


        // -------------------------------------
        // Write and read x5
        // -------------------------------------

        write_register(
            5'd5,
            32'hCAFE_BABE
        );

        check_register(
            5'd5,
            5'd1,
            32'hCAFE_BABE,
            32'h1234_5678
        );


        // -------------------------------------
        // Write and read x31
        // -------------------------------------

        write_register(
            5'd31,
            32'hFFFF_FFFF
        );

        check_register(
            5'd31,
            5'd5,
            32'hFFFF_FFFF,
            32'hCAFE_BABE
        );


        // -------------------------------------
        // Overwrite register test
        // -------------------------------------

        write_register(
            5'd1,
            32'hAAAA_AAAA
        );

        check_register(
            5'd1,
            5'd5,
            32'hAAAA_AAAA,
            32'hCAFE_BABE
        );


        // -------------------------------------
        // Reset register file
        // -------------------------------------

        rst = 1'b0;

        #10;

        rst = 1'b1;

        #5;


        // Verify registers were cleared
        check_register(
            5'd1,
            5'd5,
            32'd0,
            32'd0
        );


        // -------------------------------------
        // Test complete
        // -------------------------------------

        $display("------------------------------");
        $display("ALL TESTS COMPLETED");
        $display("------------------------------");

        $finish;

    end

endmodule