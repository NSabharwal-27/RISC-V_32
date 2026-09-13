module pc32(
    input logic clk,
    input logic rst,

    input logic [31:0] i_pc_next,
    output logic [31:0] o_pc
);

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        o_pc <= 32'b0;
    end
    
    else begin
        o_pc <= i_pc_next;
    end
end

endmodule