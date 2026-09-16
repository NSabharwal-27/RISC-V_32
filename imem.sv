module imem(
    input logic [31:0] i_addr,
    output logic [31:0] o_instr
);
/* 256 rows of mem, 32 bits wide each. */
reg [31:0] rom [1023:0];

initial begin
    $readmemh("./testbenches/imem_program.hex", rom);
end

assign instr = ram[addr[31:2]];
endmodule