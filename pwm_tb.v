`timescale 1ns / 1ps

module pwm_tb;

  // Inputs
  reg clk;
  reg reset;

  reg [7:0] hi;
  reg [7:0] lo;

  wire pwm_wire;

  pwm uut (
    .clk (clk),
    .srst(reset),
    .en  (~reset),
    .hi  (hi),
    .lo  (lo),
    .pwm_o (pwm_wire)
  );

  initial begin
    clk = 0;
    reset = 1;
    hi = 0;
    lo = 0;
    // Wait 100 ns for global reset to finish
    #100;
    reset = 0;
    #100;
    hi = 5;
    lo = 11;
    #300;
    hi = 8;
    lo = 12;
    #300;
    hi = 2;
    lo = 8;
   end

   initial
      $timeformat (-9, 3, " ns", 13);

   parameter CLK_PERIOD = 5;

   initial 
      forever
         #(CLK_PERIOD/2) clk = ~clk;

endmodule

