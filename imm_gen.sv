include imm_instr_format;

module imm_gen(
    input logic [31:0] i_instr,
    input logic [2:0] i_imm_sel,
    output logic [31:0] o_imm
);

always_comb begin
    unique case(i_imm_sel)
        INSTR_FORM_I : o_imm = {{20{i_instr[31]}}, i_instr[31:20]};
        INSTR_FORM_S : o_imm = {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]}
        INSTR_FORM_B : o_imm = {{19{i_instr[31]}}, i_instr[31], i_instr[7],
                                    i_instr[30:25], i_instr[11:8], 1'b0 };
        INSTR_FORM_U : o_imm = {i_instr[31:12], 12'b0};
        INSTR_FORM_J : o_imm = {{11{i_instr[31]}}, i_instr[31], i_instr[19:12],
                                    i_instr[20], i_instr[30:21], 1'b0};
        default      : o_imm = 32'b0;
    endcase
end
endmodule