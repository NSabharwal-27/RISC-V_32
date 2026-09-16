package imm_instr_format;

    typedef enum logic [2:0] {
      INSTR_FORM_I,
      INSTR_FORM_S,
      INSTR_FORM_B,
      INSTR_FORM_U,
      INSTR_FORM_J,
      INSTR_FORM_UNKN  
    };

endpackage : imm_instr_format