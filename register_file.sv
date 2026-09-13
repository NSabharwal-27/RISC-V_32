/*
 * RV-32I has 32 General purpose 32-bit registers,
 * register x0 is always hardwired to be 0. 
 */

module register_file(
        input logic clk,
        input logic rst,

        /* All Input signal we will need */
        input logic i_we,
        input logic [31:0] i_rd_data,
        input logic [4:0]  i_rd_addr,
        input logic [4:0]  i_rs1_addr,
        input logic [4:0]  i_rs2_addr,

        /* All the output signal we will need */
        output logic [31:0] o_rs1,
        output logic [31:0] o_rs2
);

logic [31:0] register_file [0:31];

assign o_rs1 = (i_rs1_addr == 5'b0) ? 32'b0 : register_file[i_rs1_addr];
assign o_rs2 = (i_rs2_addr == 5'b0) ? 32'b0 : register_file[i_rs2_addr];

always_ff @(posedge clk or negedge rst) begin

    if (!rst) begin
        for(int i = 0; i < 32; i = i+1) begin
            register_file[i] <= 32'b0;
        end
    end

    else if (i_we && i_rd_addr != 5'b0) begin
        register_file[i_rd_addr] <= i_rd_data;
    end        
end

endmodule