// Program Counter: 4-bit, synchronous active-high reset, +1 every clock
module pc (
    input  wire       clk,
    input  wire       reset,
    output reg  [3:0] pc_out
);
    always @(posedge clk) begin
        if (reset)
            pc_out <= 4'd0;
        else
            pc_out <= pc_out + 4'd1;   // wraps 15 -> 0
    end
endmodule
