`timescale 1ns / 1ps
module tb_alu;
    reg  [7:0] acc_in, imm;
    reg  [2:0] alu_op;
    wire [7:0] result;
    integer    errors;

    alu uut (.acc_in(acc_in), .imm(imm), .alu_op(alu_op), .result(result));

    task test;
        input [2:0] op;
        input [7:0] a;
        input [7:0] b;
        input [7:0] expected;
        input [8*10-1:0] name;
        begin
            alu_op = op; acc_in = a; imm = b;
            #5;
            $display("%-10s ACC=%h imm=%h -> result=%h (expected %h)", name, a, b, result, expected);
            if (result !== expected) begin
                errors = errors + 1;
                $display("  ERROR");
            end
        end
    endtask

    initial begin
        errors = 0;
        // alu_op: 0=LDI 1=ADD 2=SUB 3=AND 4=OR
        test(3'd0, 8'h00, 8'h3C, 8'h3C, "LDI");
        test(3'd0, 8'hAA, 8'h00, 8'h00, "LDI zero");
        test(3'd1, 8'h3C, 8'h0F, 8'h4B, "ADD");
        test(3'd1, 8'hFF, 8'h01, 8'h00, "ADD wrap");   // carry discarded
        test(3'd1, 8'hF0, 8'h20, 8'h10, "ADD wrap2");
        test(3'd2, 8'h4B, 8'h0B, 8'h40, "SUB");
        test(3'd2, 8'h4A, 8'h4A, 8'h00, "SUB zero");
        test(3'd2, 8'h00, 8'h01, 8'hFF, "SUB wrap");   // modulo 256
        test(3'd3, 8'h40, 8'hF0, 8'h40, "AND");
        test(3'd3, 8'hFF, 8'h00, 8'h00, "AND zero");
        test(3'd4, 8'h40, 8'h0A, 8'h4A, "OR");
        test(3'd4, 8'h00, 8'h00, 8'h00, "OR zero");

        if (errors == 0) $display("PASS: tb_alu - all checks passed.");
        else             $display("FAIL: tb_alu - %0d error(s).", errors);
        $finish;
    end
endmodule
