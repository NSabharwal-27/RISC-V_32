module imem(
    input logic [31:0] addr,
    output logic [31:0] instr
);
/* 256 rows of mem, 32 bits wide each. */
reg [31:0] rom [1023:0];

initial begin
    $readmemh("./testbenches/imem_program.hex", rom);
end

assign instr = ram[addr[31:2]];
endmodule