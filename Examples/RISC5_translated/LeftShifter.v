`timescale 1ns / 1 ps
module LeftShifter(   // translated from Lola
input [31:0] x,
input [4:0] sc,
output [31:0] y);
wire [1:0] sc0, sc1;
wire [31:0] t1, t2;
assign y = (sc[4] ? {t2[15:0], 16'h0} : t2);
assign sc0 = sc[1:0];
assign sc1 = sc[3:2];
assign t1 = ((sc0 == 3) ? {x[28:0], 3'h0} : ((sc0 == 2) ? {x[29:0], 2'h0} : ((sc0 == 1) ? {x[30:0], 1'h0} : x)));
assign t2 = ((sc1 == 3) ? {t1[19:0], 12'h0} : ((sc1 == 2) ? {t1[23:0], 8'h0} : ((sc1 == 1) ? {t1[27:0], 4'h0} : t1)));
endmodule
