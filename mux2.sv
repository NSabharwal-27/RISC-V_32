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

logic [31:0] p;
logic [31:0] g;

assign p = a ^ b;
assign g = a & b;

assign s = p ^ cin;
assign cout = g | (p & cin);

endmodule