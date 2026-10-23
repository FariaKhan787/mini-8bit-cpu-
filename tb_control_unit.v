`timescale 1ns / 1ps
module tb_control_unit;
    reg  [3:0] opcode;
    wire [2:0] alu_op;
    wire       acc_we;
    integer    errors, i;

    reg [2:0] exp_op;
    reg       exp_we;

    control_unit uut (.opcode(opcode), .alu_op(alu_op), .acc_we(acc_we));

    initial begin
        errors = 0;
        // test all 16 opcodes
        for (i = 0; i < 16; i = i + 1) begin
            opcode = i[3:0];
            #5;
            if (i >= 1 && i <= 5) begin   // LDI,ADD,SUB,AND,OR
                exp_we = 1'b1;
                exp_op = i - 1;           // 0=LDI 1=ADD 2=SUB 3=AND 4=OR
            end else begin                // NOP
                exp_we = 1'b0;
                exp_op = 3'd0;
            end
            $display("opcode=%b  alu_op=%0d acc_we=%b (expected %0d, %b)",
                     opcode, alu_op, acc_we, exp_op, exp_we);
            if (acc_we !== exp_we || alu_op !== exp_op) begin
                errors = errors + 1;
                $display("  ERROR at opcode %b", opcode);
            end
        end

        if (errors == 0) $display("PASS: tb_control_unit - all 16 opcodes correct.");
        else             $display("FAIL: tb_control_unit - %0d error(s).", errors);
        $finish;
    end
endmodule
