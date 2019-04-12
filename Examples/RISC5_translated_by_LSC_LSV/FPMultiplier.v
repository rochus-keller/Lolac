`timescale 1ns / 1 ps
module FPMultiplier(   // translated from Lola
input clk, run,
input [31:0] x, y,
output stall,
output [31:0] z);
??? [4:0] S;
??? [47:0] P;
wire sign;
wire [7:0] xe, ye;
wire [8:0] e0, e1;
wire [23:0] w0;
wire [24:0] w1, z0;
assign stall = (run & (S != 25));
assign z = (((xe == 0) | (ye == 0)) ? 0 : (~e1[8] ? {sign, e1[7:0], z0[23:1]} : (~e1[7] ? {sign, 8'hFF, z0[23:1]} : 0)));
assign sign = (x[31] ^ y[31]);
assign xe = x[30:23];
assign ye = y[30:23];
assign e0 = ({1'h0, xe} + {1'h0, ye});
assign e1 = ((e0 - 127) + {8'h0, P[47]});
assign w0 = (P[0] ? {1'h1, y[22:0]} : 0);
assign w1 = ({1'h0, P[47:24]} + {1'h0, w0});
assign z0 = (P[47] ? (P[47:23] + 1) : (P[46:22] + 1));
endmodule
