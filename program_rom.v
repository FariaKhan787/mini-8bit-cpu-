// Program ROM: 16 x 12-bit, combinational read, Set 1 program
module program_rom (
    input  wire [3:0]  addr,
    output reg  [11:0] instr
);
    always @(*) begin
        case (addr)
            4'd0:    instr = 12'h13C;  // LDI 0x3C
            4'd1:    instr = 12'h20F;  // ADD 0x0F
            4'd2:    instr = 12'h30B;  // SUB 0x0B
            4'd3:    instr = 12'h4F0;  // AND 0xF0
            4'd4:    instr = 12'h50A;  // OR  0x0A
            4'd5:    instr = 12'h34A;  // SUB 0x4A
            4'd6:    instr = 12'h301;  // SUB 0x01
            default: instr = 12'h000;  // addresses 7-15: NOP
        endcase
    end
endmodule
