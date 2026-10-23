// Top-level Mini 8-bit Accumulator CPU (Set 1)
module cpu_top (
    input  wire       CLK,
    input  wire       RESET,
    output wire [7:0] Q,
    output wire       Z,
    output wire [3:0] PC
);
    wire [11:0] instr;
    wire [2:0]  alu_op;
    wire        acc_we;
    wire [7:0]  alu_result;

    pc u_pc (
        .clk    (CLK),
        .reset  (RESET),
        .pc_out (PC)
    );

    program_rom u_rom (
        .addr  (PC),
        .instr (instr)
    );

    control_unit u_ctrl (
        .opcode (instr[11:8]),
        .alu_op (alu_op),
        .acc_we (acc_we)
    );

    alu u_alu (
        .acc_in (Q),
        .imm    (instr[7:0]),
        .alu_op (alu_op),
        .result (alu_result)
    );

    acc_register u_acc (
        .clk   (CLK),
        .reset (RESET),
        .we    (acc_we),
        .d     (alu_result),
        .acc   (Q),
        .z     (Z)
    );
endmodule
