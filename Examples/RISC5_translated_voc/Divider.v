`timescale 1ns / 1 ps
module Divider(   // translated from Lola
input clk, run, u,
output stall,
input [31:0] x, y,
output [31:0] quot, rem);
reg [5:0] S;
reg [63:0] RQ;
wire sign;
wire [31:0] x0, w0, w1;
assign stall = (run & (S != 33));
assign quot = (~sign ? RQ[31:0] : ((RQ[63:32] == 0) ? ( - RQ[31:0]) : (( - RQ[31:0]) - 1)));
assign rem = (~sign ? RQ[63:32] : ((RQ[63:32] == 0) ? 0 : (y - RQ[63:32])));
assign sign = (x[31] & u);
assign x0 = (sign ? ( - x) : x);
assign w0 = RQ[62:31];
assign w1 = (w0 - y);
always @ (posedge clk) begin S <= (run ? (S + 1) : 0);
RQ <= ((S == 0) ? {32'h0, x0} : {(w1[31] ? w0 : w1), RQ[30:0], ~w1[31]});
end
endmodule
