`timescale 1ns/1ps

module mux2_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic sel;
    logic [31:0] cout;

    logic [31:0] expected;

    mux2 dut(
        .a      (a),
        .b      (b),
        .sel    (sel),
        .cout   (cout)
    );

    task automatic check(
        input logic [31:0]  test_a,
        input logic [31:0]  test_b,
        input logic         test_sel
    );
        begin
                a = test_a;
                b = test_b;
                sel = test_sel;

                #10;

                expected = (test_sel ? b : a);

                //Compare DUT output with expected output
                if (cout !== expected) begin 
                    $display("FAIL: a=%h b=%h sel=%b | Expected=%h | Got=%h",
                        a, b, sel, expected, cout); 
                end
                else begin 
                    $display("PASS: a=%h b=%h sel=%b | Output=%h",
                        a, b, sel, cout); 
                    end
                end
            endtask

    // Test sequence
    initial begin

        $display("Starting mux2 testbench...");

        // Basic tests
        check(32'h00000000, 32'hFFFFFFFF, 1'b0);
        check(32'h00000000, 32'hFFFFFFFF, 1'b1);

        // Additional tests
        check(32'h12345678, 32'hABCDEF00, 1'b0);
        check(32'h12345678, 32'hABCDEF00, 1'b1);

        // Random tests
        repeat (10) begin
            check(
                $urandom(),
                $urandom(),
                $urandom_range(0, 1)
            );
        end

        $display("Testbench completed.");

        $finish;
    end

endmodule