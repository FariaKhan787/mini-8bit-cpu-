`timescale 1ns / 1ps
module tb_pc;
    reg        clk, reset;
    wire [3:0] pc_out;
    integer    errors, i;

    pc uut (.clk(clk), .reset(reset), .pc_out(pc_out));

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task check;
        input [3:0] expected;
        input [8*24-1:0] msg;
        begin
            $display("%-24s reset=%b PC=%0d (expected %0d)", msg, reset, pc_out, expected);
            if (pc_out !== expected) begin
                errors = errors + 1;
                $display("  ERROR: PC mismatch");
            end
        end
    endtask

    initial begin
        errors = 0;
        reset = 1'b1;
        @(posedge clk); #1; check(4'd0, "after reset edge");
        reset = 1'b0;

        // count 1..15, then wrap to 0
        for (i = 1; i <= 16; i = i + 1) begin
            @(posedge clk); #1;
            check(i % 16, "counting");
        end

        // run a few more, then assert reset in the middle
        repeat (3) begin @(posedge clk); #1; end   // PC = 3
        check(4'd3, "before mid-run reset");
        reset = 1'b1;
        #2;                                         // between edges: must NOT change (synchronous)
        check(4'd3, "reset high, no edge yet");
        @(posedge clk); #1; check(4'd0, "reset at edge -> 0");
        @(posedge clk); #1; check(4'd0, "reset held -> stays 0");
        reset = 1'b0;
        @(posedge clk); #1; check(4'd1, "resumes counting");

        if (errors == 0) $display("PASS: tb_pc - all checks passed.");
        else             $display("FAIL: tb_pc - %0d error(s).", errors);
        $finish;
    end
endmodule
