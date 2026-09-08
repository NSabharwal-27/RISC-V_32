import alu_states_pkg::*;

module alu(
            input logic [31:0] i_data1,
            input logic [31:0] i_data2,
            input logic [3:0] i_alusel,
            output logic [31:0] o_data
);

/*  On RISC-V 32 bit architecture shift instructions operate
    on the lower 5 bits */
wire [4:0] shift_bits = i_data2[4:0];

always_comb begin
    case (i_alusel)
        ALU_ADD : o_data = i_data1 + i_data2;
        ALU_SUB : o_data = i_data1 - i_data2;
        ALU_AND : o_data = i_data1 & i_data2;
        ALU_OR  : o_data = i_data1 | i_data2;
        ALU_XOR : o_data = i_data1 ^ i_data2;
        ALU_SLT : o_data = ($signed(i_data1) < $signed(i_data2)) ? 32'd1 : 32'd0;
        ALU_SLTU: o_data = (i_data1 < i_data2) ? 32'd1 : 32'd0;
        ALU_SLL : o_data = i_data1 << shift_bits;
        ALU_SRL : o_data = i_data1 >> shift_bits;
        ALU_SRA : o_data = $signed(i_data1) >>> shift_bits;
        default: o_data = 32'd0;
    endcase
end

endmodule