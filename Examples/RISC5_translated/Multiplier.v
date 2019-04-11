`timescale 1ns / 1 ps
module Multiplier(   // translated from Lola
input clk, run, u,
output stall,
input [31:0] x, y,
output [63:0] z);
??? [5:0] S;
??? [63:0] P;
wire [31:0] w0;
wire [32:0] w1;
assign stall = (run & (S != 33));
assign z = P;
assign w0 = (P[0] ? y : 0);
assign w1 = (((S == 32) & u) ? ({P[63], P[63:32]} - {w0[31], w0}) : ({P[63], P[63:32]} + {w0[31], w0}));
endmodule
