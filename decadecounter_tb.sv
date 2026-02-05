`timescale 1ns/1ps

module tb_decade_counter;

  // Testbench signals
  logic clk;
  logic rst;
  logic en;
  logic [3:0] count;

  // Instantiate DUT
  decade_counter dut (
    .clk   (clk),
    .rst   (rst),
    .en    (en),
    .count (count)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    en  = 0;

    // Apply reset
    #10;
    rst = 0;
    en  = 1;

    // Let counter run for several cycles
    repeat (15) begin
      @(posedge clk);
      $display("Time=%0t | Count=%0d", $time, count);
    end

    // Disable enable
    en = 0;
    repeat (3) @(posedge clk);

    // Enable again
    en = 1;
    repeat (5) @(posedge clk);

    $finish;
  end

endmodule
