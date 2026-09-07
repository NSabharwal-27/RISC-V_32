`timescale 1ns/1ps

module fulladder32_tb;

    //testbench signals
    logic [31:0] a;
    logic [31:0] b;
    logic        cin;
    logic [31:0] s;
    logic        cout;

    //Expected results should be 33-bits so we can check overflow
    logic [32:0] expected;

    fulladder32 dut(
        .a      (a),
        .b      (b),
        .cin    (cin),
        .s      (s),
        .cout   (cout)
    );

    // Everything below this is AI generated.
    // Test task
    task automatic check(
        input logic [31:0] test_a,
        input logic [31:0] test_b,
        input logic        test_cin
    );
        begin
            a   = test_a;
            b   = test_b;
            cin = test_cin;

            #10;

            // Calculate expected result
            expected = {1'b0, test_a} +
                       {1'b0, test_b} +
                       test_cin;

            // Compare DUT output with expected output
            if ({cout, s} !== expected) begin
                $display("FAIL: a=%h b=%h cin=%b | Expected=%h | Got cout=%b s=%h",
                         a, b, cin, expected, cout, s);
            end
            else begin
                $display("PASS: a=%h b=%h cin=%b | Result=%h",
                         a, b, cin, {cout, s});
            end
        end
    endtask

    // Test sequence
    initial begin

        $display("Starting fulladder32 testbench...");

        // Basic tests
        check(32'h00000000, 32'h00000000, 1'b0);
        check(32'h00000001, 32'h00000001, 1'b0);
        check(32'h00000001, 32'h00000001, 1'b1);

        // Carry tests
        check(32'hFFFFFFFF, 32'h00000001, 1'b0);
        check(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b0);
        check(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1);

        // Random tests
        repeat (10) begin
            check($urandom(), $urandom(), $urandom_range(0,1));
        end

        $display("Testbench completed.");

        $finish;
    end

endmodule