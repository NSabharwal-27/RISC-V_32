/*
 * R, I, S, SB Instructions all read
 * rs1 from bits 19-15 so we need 5 bits for input reg
 */

module register_file(
        input logic clk,
        input logic rst,
        input logic i_w_enable,
        input logic i_reg_write,
        input logic [4:0] i_rs1,
        input logic [4:0] i_rs2,
        input logic [4:0] i_w_register,
        input logic [31:0] i_w_data,
        output logic [31:0] o_r_data_1,
        output logic [31:0] o_r_data_2
);

always_ff @(posedge clk)
    if ()


endmodule