`timescale 1ns / 1 ps
module FPDivider(   // translated from Lola
input clk, run,
input [31:0] x, y,
output stall,
output [31:0] z);
reg [4:0] S;
reg [23:0] R;
reg [25:0] Q;
wire sign;
wire [7:0] xe, ye;
wire [8:0] e0, e1;
wire [24:0] r0, r1, d;
wire [25:0] q0;
wire [24:0] z0, z1;
assign stall = (run & (S != 26));
assign z = ((xe == 0) ? 0 : ((ye == 0) ? {sign, 8'hFF, 23'h0} : (~e1[8] ? {sign, e1[7:0], z1[23:1]} : (~e1[7] ? {sign, 8'hFF, z0[23:1]} : 0))));
assign sign = (x[31] ^ y[31]);
assign xe = x[30:23];
assign ye = y[30:23];
assign e0 = ({1'h0, xe} - {1'h0, ye});
assign e1 = ((e0 + 126) + {8'h0, Q[25]});
assign r0 = ((S == 0) ? {2'h1, x[22:0]} : {R, 1'h0});
assign r1 = (d[24] ? 0 : d);
assign d = (r0 - {2'h1, y[22:0]});
assign q0 = ((S == 0) ? 0 : Q);
assign z0 = (Q[25] ? Q[25:1] : Q[24:0]);
assign z1 = (z0 + 1);
always @ (posedge clk) begin S <= (run ? (S + 1) : 0);
R <= r1[23:0];
Q <= {q0[24:0], ~d[24]};
end
endmodule
