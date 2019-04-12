`timescale 1ns / 1 ps
module RS232T(   // translated from Lola
input clk, rst, start, fsel,
input [7:0] data,
output rdy, TxD);
??? run;
??? [11:0] tick;
??? [3:0] bitcnt;
??? [8:0] shreg;
wire endtick, endbit;
wire [11:0] limit;
assign rdy = ~run;
assign TxD = shreg[0];
assign endtick = (tick == limit);
assign endbit = (bitcnt == 9);
assign limit = (fsel ? 217 : 1302);
endmodule
