/*
 * RV-32I has 32 General purpose 32-bit registers,
 * register x0 is always hardwired to be 0. 
 */

module register_file(
        input logic clk,
        input logic rst,
        input logic i_we,
        input logic [31:0] i_rd_data,
        input logic [4:0]  i_rd_addr,
        input logic [4:0]  i_rs1_addr,
        input logic [4:0]  i_rs2_addr,

        output logic [31:0] o_rs1,
        output logic [31:0] o_rs2
);

logic [31:0] register_file;

assign o_rs1 = (i_rs1_addr == 5'b0) ? 5'b0 : register_file[i_rs1_addr];
assign o_rs2 = (i_rs2_addr == 5'b0) ? 5'b0 : register_file[i_rs2_addr];

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        register_file <= '{default: '0};
    end

    if (i_we && i_rs1_addr != 5'b0) begin
        register_file[i_rd_addr] <= i_rd_data;
    end        
end

endmodule