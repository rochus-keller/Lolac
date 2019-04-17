`timescale 1ns / 1 ps
module MouseP(   // translated from Lola
input clk, rst,
inout msclk, msdat,
output [27:0] out);
reg [9:0] x, y;
reg [2:0] btns;
reg Q0, Q1, run;
reg [31:0] shreg;
wire shift, endbit, reply;
wire [9:0] dx, dy;
wire msclk0, msdat0;
IOBUF block1 (.IO(msclk), .O(msclk0), .I(1'h0), .T(rst));
IOBUF block2 (.IO(msdat), .O(msdat0), .I(1'h0), .T((run | shreg[0])));
assign out = {run, btns, 2'h0, y, 2'h0, x};
assign shift = (Q1 & ~Q0);
assign endbit = (run & ~shreg[0]);
assign reply = (~run & ~shreg[1]);
assign dx = {{2{shreg[5]}}, (shreg[7] ? 8'h0 : shreg[19:12])};
assign dy = {{2{shreg[6]}}, (shreg[8] ? 8'h0 : shreg[30:23])};
always @ (posedge clk) begin x <= (~rst ? 10'h0 : (endbit ? (x + dx) : x));
y <= (~rst ? 10'h0 : (endbit ? (y + dy) : y));
btns <= (~rst ? 3'h0 : (endbit ? {shreg[1], shreg[3], shreg[2]} : btns));
Q0 <= msclk0;
Q1 <= Q0;
run <= (rst & (reply | run));
shreg <= (~rst ? -536 : ((endbit | reply) ? 32'hFFFFFFFF : (shift ? {msdat0, shreg[31:1]} : shreg)));
end
endmodule
