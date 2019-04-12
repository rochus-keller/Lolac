`timescale 1ns / 1 ps
module RS232R(   // translated from Lola
input clk, rst, done, RxD, fsel,
output rdy,
output [7:0] data);
??? run, stat, Q0, Q1;
??? [11:0] tick;
??? [3:0] bitcnt;
??? [7:0] shreg;
wire endtick, midtick, endbit;
wire [11:0] limit;
assign rdy = stat;
assign data = shreg;
assign endtick = (tick == limit);
assign midtick = (tick == {1'h0, limit[11:1]});
assign endbit = (bitcnt == 8);
assign limit = (fsel ? 217 : 1302);
endmodule
