`timescale 1ns / 1 ps
module RISC5(   // translated from Lola
input clk, rst, irq, stallX,
input [31:0] inbus, codebus,
output [23:0] adr,
output rd, wr, ben,
output [31:0] outbus);
??? [21:0] PC;
??? [31:0] IR;
??? N, Z, C, OV, stallL1;
??? [31:0] H;
??? irq1, intEnb, intPnd, intMd;
??? [25:0] SPC;
wire [21:0] pcmux, pcmux0, nxpc;
wire cond, S, sa, sb, sc, p, q, u, v;
wire [3:0] op, ira, ira0, irb, irc;
wire [2:0] cc;
wire [15:0] imm;
wire [19:0] off;
wire [21:0] disp;
wire regwr, stall, stallL0, stallM, stallD, stallFA, stallFM, stallFD, intAck, nn, zz, cx, vv;
wire [31:0] A, B, C0, C1, aluRes, regmux, inbus1, lshout, rshout, quotient, remainder;
wire [63:0] product;
wire [31:0] fsum, fprod, fquot;
wire Add, Sub, Mul, Div, Fadd, Fsub, Fmul, Fdiv, Ldr, Str, Br, RTI;
assign adr = (stallL0 ? (B[23:0] + {{4{off[19]}}, off}) : {pcmux, 2'h0});
assign rd = ((Ldr & ~stallX) & ~stallL1);
assign wr = ((Str & ~stallX) & ~stallL1);
assign ben = ((((p & ~q) & v) & ~stallX) & ~stallL1);
assign outbus = (~ben ? A : (adr[1] ? (adr[0] ? {A[7:0], 24'h0} : {8'h0, A[7:0], 16'h0}) : (adr[0] ? {16'h0, A[7:0], 8'h0} : {24'h0, A[7:0]})));
Registers regs(.clk(clk), .wr(regwr), .rno0(ira0), .rno1(irb), .rno2(irc), .din(regmux), .dout0(A), .dout1(B), .dout2(C0));
Multiplier mulUnit(.clk(clk), .run(Mul), .u(~u), .stall(stallM), .x(B), .y(C1), .z(product));
Divider divUnit(.clk(clk), .run(Div), .u(~u), .stall(stallD), .x(B), .y(C1), .quot(quotient), .rem(remainder));
LeftShifter LshUnit(.x(B), .sc(C1[4:0]), .y(lshout));
RightShifter RshUnit(.x(B), .sc(C1[4:0]), .md(IR[16]), .y(rshout));
FPAdder faddUnit(.clk(clk), .run((Fadd | Fsub)), .u(u), .v(v), .stall(stallFA), .x(B), .y({(Fsub ^ C0[31]), C0[30:0]}), .z(fsum));
FPMultiplier fmulUnit(.clk(clk), .run(Fmul), .stall(stallFM), .x(B), .y(C0), .z(fprod));
FPDivider fdivUnit(.clk(clk), .run(Fdiv), .stall(stallFD), .x(B), .y(C0), .z(fquot));
assign pcmux = (~rst ? 4192256 : (intAck ? 1 : pcmux0));
assign pcmux0 = (stall ? PC : (RTI ? SPC[21:0] : ((Br & cond) ? (u ? (disp + nxpc) : C0[23:2]) : nxpc)));
assign nxpc = (PC + 1);
assign cond = (IR[27] ^ (((((((((cc == 0) & N) | ((cc == 1) & Z)) | ((cc == 2) & C)) | ((cc == 3) & OV)) | ((cc == 4) & (C | Z))) | ((cc == 5) & S)) | ((cc == 6) & (S | Z))) | (cc == 7)));
assign S = (N ^ OV);
assign sa = aluRes[31];
assign sb = B[31];
assign sc = C1[31];
assign p = IR[31];
assign q = IR[30];
assign u = IR[29];
assign v = IR[28];
assign op = IR[19:16];
assign ira = IR[27:24];
assign ira0 = (Br ? 4'hF : ira);
assign irb = IR[23:20];
assign irc = IR[3:0];
assign cc = IR[26:24];
assign imm = IR[15:0];
assign off = IR[19:0];
assign disp = IR[21:0];
assign regwr = (((~p & ~stall) | ((Ldr & ~stallX) & ~stallL1)) | (((Br & cond) & v) & ~stallX));
assign stall = ((((((stallL0 | stallM) | stallD) | stallFA) | stallFM) | stallFD) | stallX);
assign stallL0 = ((Ldr | Str) & ~stallL1);
assign intAck = (((intPnd & intEnb) & ~intMd) & ~stall);
assign nn = (RTI ? SPC[25] : (regwr ? regmux[31] : N));
assign zz = (RTI ? SPC[24] : (regwr ? (regmux == 0) : Z));
assign cx = (RTI ? SPC[23] : (Add ? (((sb & sc) | ((~sa & ~sb) & sc)) | (((~sa & sb) & ~sc) & sa)) : (Sub ? (((~sb & sc) | ((sa & ~sb) & ~sc)) | ((sa & sb) & sc)) : C)));
assign vv = (RTI ? SPC[22] : (Add ? (((sa & ~sb) & ~sc) | ((~sa & sb) & sc)) : (Sub ? (((sa & ~sb) & sc) | ((~sa & sb) & ~sc)) : OV)));
assign C1 = (q ? {{16{v}}, imm} : C0);
assign aluRes = (~op[3] ? (~op[2] ? (~op[1] ? (~op[0] ? (q ? (~u ? {{16{v}}, imm} : {imm, 16'h0}) : (~u ? C0 : (~v ? H : {N, Z, C, OV, 20'h0, 8'h5B}))) : lshout) : rshout) : (~op[1] ? (~op[0] ? (B & C1) : (B & ~C1)) : (~op[0] ? (B | C1) : (B ^ C1)))) : (~op[2] ? (~op[1] ? (~op[0] ? ((B + C1) + {31'h0, (u & C)}) : ((B - C1) - {31'h0, (u & C)})) : (~op[0] ? product[31:0] : quotient)) : (~op[1] ? fsum : (~op[0] ? fprod : fquot))));
assign regmux = (Ldr ? inbus1 : ((Br & v) ? {8'h0, nxpc, 2'h0} : aluRes));
assign inbus1 = (~ben ? inbus : {24'h0, (adr[1] ? (adr[0] ? inbus[31:24] : inbus[23:16]) : (adr[0] ? inbus[15:8] : inbus[7:0]))});
assign Add = (~p & (op == 8));
assign Sub = (~p & (op == 9));
assign Mul = (~p & (op == 10));
assign Div = (~p & (op == 11));
assign Fadd = (~p & (op == 12));
assign Fsub = (~p & (op == 13));
assign Fmul = (~p & (op == 14));
assign Fdiv = (~p & (op == 15));
assign Ldr = ((p & ~q) & ~u);
assign Str = ((p & ~q) & u);
assign Br = (p & q);
assign RTI = (((Br & ~u) & ~v) & IR[4]);
endmodule
