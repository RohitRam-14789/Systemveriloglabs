// 4-bit Synchronous Up Counter in SystemVerilog
module up_counter (
    input  logic clk,      // Clock signal
    input  logic rst_n,    // Active-low asynchronous reset
    output logic [3:0] q   // 4-bit counter output
);

    // always_ff ensures the block is synthesised as flip-flops
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0000;  // Reset counter to 0
        else
            q <= q + 1'b1; // Increment count on clock edge
    end

endmodule

