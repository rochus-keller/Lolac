`timescale 1ns / 1 ps
module PS2(   // translated from Lola
input clk, rst, done,
output rdy, shift,
output [7:0] data,
input PS2C, PS2D);
reg Q0, Q1;
reg [10:0] shreg;
reg [3:0] inptr, outptr;
??? [7:0] fifo[15:0];
wire endbit;
assign rdy = (inptr != outptr);
assign shift = (Q1 & ~Q0);
assign data = fifo[outptr];
assign endbit = ~shreg[0];
always @ (posedge clk) begin Q0 <= PS2C;
Q1 <= Q0;
shreg <= ((~rst | endbit) ? 11'h7FF : (shift ? {PS2D, shreg[10:1]} : shreg));
inptr <= (~rst ? 0 : (endbit ? (inptr + 1) : inptr));
outptr <= (~rst ? 0 : ((rdy & done) ? (outptr + 1) : outptr));
end
endmodule
