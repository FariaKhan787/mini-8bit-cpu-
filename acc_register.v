// ACC and Z flag registers (this module is the only owner of ACC and Z)
module acc_register (
    input  wire       clk,
    input  wire       reset,
    input  wire       we,
    input  wire [7:0] d,
    output reg  [7:0] acc,
    output reg        z
);
    always @(posedge clk) begin
        if (reset) begin
            acc <= 8'h00;
            z   <= 1'b1;
        end else if (we) begin
            acc <= d;
            z   <= (d == 8'h00);
        end
        // else: NOP -> ACC and Z unchanged
    end
endmodule
