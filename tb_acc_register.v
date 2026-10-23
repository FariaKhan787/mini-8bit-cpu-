`timescale 1ns / 1ps
module tb_acc_register;
    reg        clk, reset, we;
    reg  [7:0] d;
    wire [7:0] acc;
    wire       z;
    integer    errors;

    acc_register uut (.clk(clk), .reset(reset), .we(we), .d(d), .acc(acc), .z(z));

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task check;
        input [7:0] exp_acc;
        input       exp_z;
        input [8*28-1:0] msg;
        begin
            $display("%-28s ACC=%h Z=%b (expected %h, %b)", msg, acc, z, exp_acc, exp_z);
            if (acc !== exp_acc || z !== exp_z) begin
                errors = errors + 1;
                $display("  ERROR");
            end
        end
    endtask

    initial begin
        errors = 0;
        reset = 1'b1; we = 1'b0; d = 8'h00;
        @(posedge clk); #1; check(8'h00, 1'b1, "reset");

        reset = 1'b0; we = 1'b1; d = 8'h3C;
        @(posedge clk); #1; check(8'h3C, 1'b0, "write 3C");

        we = 1'b0; d = 8'hFF;                       // NOP: no write
        @(posedge clk); #1; check(8'h3C, 1'b0, "we=0 holds ACC and Z");

        we = 1'b1; d = 8'h00;
        @(posedge clk); #1; check(8'h00, 1'b1, "write 00 -> Z=1");

        we = 1'b0; d = 8'hAA;
        @(posedge clk); #1; check(8'h00, 1'b1, "we=0 holds Z=1");

        we = 1'b1; d = 8'hFF;
        @(posedge clk); #1; check(8'hFF, 1'b0, "write FF -> Z=0");

        // asynchronous check: d changes between edges, ACC must not change
        d = 8'h12;
        #2; check(8'hFF, 1'b0, "no change between edges");

        // reset priority over write
        reset = 1'b1; we = 1'b1; d = 8'h55;
        @(posedge clk); #1; check(8'h00, 1'b1, "reset beats write");

        if (errors == 0) $display("PASS: tb_acc_register - all checks passed.");
        else             $display("FAIL: tb_acc_register - %0d error(s).", errors);
        $finish;
    end
endmodule
