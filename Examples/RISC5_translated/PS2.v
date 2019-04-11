`timescale 1ns / 1 ps
module PS2(   // translated from Lola
input clk, rst, done,
output rdy, shift,
output [7:0] data,
input PS2C, PS2D);
??? Q0, Q1;
??? [10:0] shreg;
??? [3:0] inptr, outptr;
??? [7:0] fifo[15:0];
wire endbit;
assign rdy = (inptr != outptr);
assign shift = (Q1 & ~Q0);
assign data = fifo[outptr];
assign endbit = ~shreg[0];
endmodule
