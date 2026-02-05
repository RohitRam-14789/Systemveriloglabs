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



//testbench
// Define an interface to bundle signals
interface cnt_if (input logic clk);
    logic rst_n;
    logic [3:0] q;
endinterface

module tb_top;
    bit clk;
    
    // Clock generation (100MHz)
    always #5 clk = ~clk;

    // Instantiate the interface
    cnt_if vif(clk);

    // Instantiate the Design Under Test (DUT)
    up_counter dut (
        .clk   (vif.clk),
        .rst_n (vif.rst_n),
        .q     (vif.q)
    );

    // Verification Logic
    initial begin
        vif.rst_n = 0;   // Assert reset
        #20 vif.rst_n = 1; // Release reset
        
        #200;            // Let it count
        $display("Simulation finished at time %0t", $time);
        $finish;
    end

    // SYSTEMVERILOG ASSERTION: Check that q increments by 1
    // This runs automatically on every clock edge
    property p_increment;
        @(posedge vif.clk) disable iff (!vif.rst_n)
        vif.q == ($past(vif.q) + 1'b1);
    endproperty


    assert property (p_increment) 
        else $error("Assertion Failed: Counter did not increment correctly! Current: %d, Past: %d", vif.q, $past(vif.q));

endmodule
