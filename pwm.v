//
// Module: pwm
//
// Pulse width modulation
//
// The pwm_o output asserts when the internal counter 
// matches the hi input value and deasserts when it
// matches the lo input value, restarting a cycle.
//
`timescale 1ns / 1ps

module pwm # (
  parameter CNT_WIDTH = 8
) (
  input  wire                 clk,
  input  wire                 srst,
  input  wire                 en,
  input  wire [CNT_WIDTH-1:0] hi,
  input  wire [CNT_WIDTH-1:0] lo,
  output wire                 pwm_o
  );

  reg [CNT_WIDTH-1:0] cnt;
  reg [CNT_WIDTH-1:0] hi_l;
  reg [CNT_WIDTH-1:0] lo_l;
  wire                set_pwm;
  wire                clr_pwm;
  reg                 pwm;

  always @(posedge clk)
  begin
    if (srst) begin
      cnt <= {CNT_WIDTH{1'b0}};
    end else if (en) begin
      if (clr_pwm) begin
        cnt <= {CNT_WIDTH{1'b0}};
      end else begin
        cnt <= cnt + 1;
      end
    end
  end

  always @(posedge clk)
  begin
    if (srst) begin
      hi_l <= {CNT_WIDTH{1'b0}};
      lo_l <= {CNT_WIDTH{1'b0}};
    end else if (clr_pwm) begin
      hi_l <= hi;
      lo_l <= lo;
    end
  end

  assign set_pwm = cnt == hi_l;
  assign clr_pwm = cnt == lo_l;

  always @(posedge clk)
  begin
    if (srst)
      pwm <= 1'b0;
    else if (en) begin
      if (clr_pwm)
        pwm <= 1'b0;
      else if (set_pwm)
        pwm <= 1'b1;
    end
  end

  assign pwm_o = pwm;

endmodule


