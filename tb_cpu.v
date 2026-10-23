`timescale 1ns / 1ps
module tb_cpu;
    reg        CLK;
    reg        RESET;
    wire [7:0] Q;
    wire       Z;
    wire [3:0] PC;

    integer errors;
    integer i;

    reg [7:0]    exp_q    [0:8];
    reg          exp_z    [0:8];
    reg [3:0]    exp_pc   [0:8];
    reg [8*12-1:0] name   [0:8];

    cpu_top uut (.CLK(CLK), .RESET(RESET), .Q(Q), .Z(Z), .PC(PC));

    // 10 ns clock
    initial CLK = 1'b0;
    always #5 CLK = ~CLK;

    task check;
        input integer n;
        begin
            $display("%0d  | %-12s | Q=%h (%b) | Z=%b | PC=%0d", n, name[n], Q, Q, Z, PC);
            if (Q !== exp_q[n] || Z !== exp_z[n] || PC !== exp_pc[n]) begin
                errors = errors + 1;
                $display("ERROR at cycle %0d: expected Q=%h Z=%b PC=%0d", n, exp_q[n], exp_z[n], exp_pc[n]);
            end
        end
    endtask

    initial begin
        errors = 0;
        // cycle 0: reset
        name[0]="RESET";     exp_q[0]=8'h00; exp_z[0]=1; exp_pc[0]=0;
        name[1]="LDI 3C";    exp_q[1]=8'h3C; exp_z[1]=0; exp_pc[1]=1;
        name[2]="ADD 0F";    exp_q[2]=8'h4B; exp_z[2]=0; exp_pc[2]=2;
        name[3]="SUB 0B";    exp_q[3]=8'h40; exp_z[3]=0; exp_pc[3]=3;
        name[4]="AND F0";    exp_q[4]=8'h40; exp_z[4]=0; exp_pc[4]=4;
        name[5]="OR 0A";     exp_q[5]=8'h4A; exp_z[5]=0; exp_pc[5]=5;
        name[6]="SUB 4A";    exp_q[6]=8'h00; exp_z[6]=1; exp_pc[6]=6;
        name[7]="SUB 01";    exp_q[7]=8'hFF; exp_z[7]=0; exp_pc[7]=7;
        name[8]="NOP (extra)"; exp_q[8]=8'hFF; exp_z[8]=0; exp_pc[8]=8;

        RESET = 1'b1;
        @(posedge CLK); #1;          // let nonblocking updates settle
        check(0);
        RESET = 1'b0;
        for (i = 1; i <= 8; i = i + 1) begin
            @(posedge CLK); #1;
            check(i);
        end

        if (errors == 0) $display("PASS: all results match the Set 1 expected table.");
        else             $display("FAIL: %0d mismatch(es).", errors);
        $finish;
    end
endmodule
