// Control Unit: decodes opcode, drives ALU select and ACC/Z write enable
module control_unit (
    input  wire [3:0] opcode,
    output reg  [2:0] alu_op,
    output reg        acc_we
);
    // ALU operation codes (shared with alu.v)
    localparam OP_LDI = 3'd0;
    localparam OP_ADD = 3'd1;
    localparam OP_SUB = 3'd2;
    localparam OP_AND = 3'd3;
    localparam OP_OR  = 3'd4;

    always @(*) begin
        // defaults prevent latches; default behaviour = NOP
        alu_op = OP_LDI;
        acc_we = 1'b0;
        case (opcode)
            4'b0001: begin alu_op = OP_LDI; acc_we = 1'b1; end
            4'b0010: begin alu_op = OP_ADD; acc_we = 1'b1; end
            4'b0011: begin alu_op = OP_SUB; acc_we = 1'b1; end
            4'b0100: begin alu_op = OP_AND; acc_we = 1'b1; end
            4'b0101: begin alu_op = OP_OR; acc_we = 1'b1; end
            default: begin alu_op = OP_LDI; acc_we = 1'b0; end  // NOP
        endcase
    end
endmodule
