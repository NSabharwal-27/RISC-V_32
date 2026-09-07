/*
 * @brief take in 3 32-bit signals and perform addition
 */
module fulladder32(   
            input   logic [31:0] a, 
            input   logic [31:0] b,
            input   logic        cin,
            output  logic [31:0] s,
            output  logic        cout
);

assign {cout, s} = a + b + cin; 

endmodule