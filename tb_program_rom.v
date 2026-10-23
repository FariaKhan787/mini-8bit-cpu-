`timescale 1ns / 1ps
module tb_program_rom;
    reg  [3:0]  addr;
    wire [11:0] instr;
    reg  [11:0] expected [0:15];
    integer     errors, i;

    program_rom uut (.addr(addr), .instr(instr));

    initial begin
        errors = 0;
        expected[0]  = 12'h13C;  // LDI 3C
        expected[1]  = 12'h20F;  // ADD 0F
        expected[2]  = 12'h30B;  // SUB 0B
        expected[3]  = 12'h4F0;  // AND F0
        expected[4]  = 12'h50A;  // OR  0A
        expected[5]  = 12'h34A;  // SUB 4A
        expected[6]  = 12'h301;  // SUB 01
        for (i = 7; i < 16; i = i + 1) expected[i] = 12'h000;  // NOP

        for (i = 0; i < 16; i = i + 1) begin
            addr = i[3:0];
            #5;   // combinational read, just wait for it to settle
            $display("addr=%2d  instr=%h  opcode=%b operand=%h (expected %h)",
                     addr, instr, instr[11:8], instr[7:0], expected[i]);
            if (instr !== expected[i]) begin
                errors = errors + 1;
                $display("  ERROR: ROM mismatch at address %0d", i);
            end
        end

        if (errors == 0) $display("PASS: tb_program_rom - all 16 locations match.");
        else             $display("FAIL: tb_program_rom - %0d error(s).", errors);
        $finish;
    end
endmodule
