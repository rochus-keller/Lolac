`timescale 1ns / 1 ps
module RISC5Top(   // translated from Lola
input CLK50M,
input [3:0] btn,
input [7:0] swi,
input RxD,
output TxD,
output [7:0] leds,
output SRce0, SRce1, SRwe, SRoe,
output [3:0] SRbe,
output [17:0] SRadr,
inout [31:0] SRdat,
input [1:0] MISO,
output [1:0] SCLK, MOSI, SS,
output NEN, hsync, vsync,
output [2:0] RGB,
input PS2C, PS2D,
inout msclk, msdat,
inout [7:0] gpio);
reg clk, rst, bitrate;
reg [7:0] Lreg;
reg [15:0] cnt0;
reg [31:0] cnt1;
reg [3:0] spiCtrl;
reg [7:0] gpout, gpoc;
wire dmy;
wire [23:0] adr;
wire [3:0] iowadr;
wire rd, wr, ben, ioenb, dspreq, be0, be1;
wire [31:0] inbus, inbus0, outbus, romout, codebus;
wire [7:0] dataTx, dataRx, dataKbd;
wire rdyRx, doneRx, startTx, rdyTx, rdyKbd, doneKbd;
wire [27:0] dataMs;
wire limit;
wire [31:0] spiRx;
wire spiStart, spiRdy, MOSI1, SCLK1;
wire [17:0] vidadr;
wire [7:0] gpin;
assign leds = Lreg;
assign SRce0 = (ben & adr[1]);
assign SRce1 = (ben & ~adr[1]);
assign SRwe = (~wr | clk);
assign SRoe = wr;
assign SRbe = {be1, be0, be1, be0};
assign SRadr = (dspreq ? vidadr : adr[19:2]);
genvar i;
generate
for (i = 0; i < 32; i = i+1) begin : bufblock1
IOBUF block (.IO(SRdat[i]), .O(inbus0[i]), .I(outbus[i]), .T(~wr));
end
endgenerate
assign SCLK = {SCLK1, SCLK1};
assign MOSI = {MOSI1, MOSI1};
assign SS = ~spiCtrl[1:0];
assign NEN = spiCtrl[3];
generate
for (i = 0; i < 8; i = i+1) begin : bufblock2
IOBUF block (.IO(gpio[i]), .O(gpin[i]), .I(gpout[i]), .T(gpoc[i]));
end
endgenerate
RISC5 riscx(.clk(clk), .rst(rst), .irq(limit), .stallX(dspreq), .inbus(inbus), .codebus(codebus), .adr(adr), .rd(rd), .wr(wr), .ben(ben), .outbus(outbus));
PROM PM(.clk(~clk), .adr(adr[10:2]), .data(romout));
RS232R receiver(.clk(clk), .rst(rst), .done(doneRx), .RxD(RxD), .fsel(bitrate), .rdy(rdyRx), .data(dataRx));
RS232T transmitter(.clk(clk), .rst(rst), .start(startTx), .fsel(bitrate), .data(dataTx), .rdy(rdyTx), .TxD(TxD));
SPI spi(.clk(clk), .rst(rst), .start(spiStart), .fast(spiCtrl[2]), .dataTx(outbus), .dataRx(spiRx), .rdy(spiRdy), .MISO((MISO[0] & MISO[1])), .MOSI(MOSI1), .SCLK(SCLK1));
VID vid(.clk(clk), .inv(swi[7]), .viddata(inbus0), .req(dspreq), .vidadr(vidadr), .hsync(hsync), .vsync(vsync), .RGB(RGB));
PS2 kbd(.clk(clk), .rst(rst), .done(doneKbd), .rdy(rdyKbd), .shift(dmy), .data(dataKbd), .PS2C(PS2C), .PS2D(PS2D));
MouseP Ms(.clk(clk), .rst(rst), .msclk(msclk), .msdat(msdat), .out(dataMs));
assign iowadr = adr[5:2];
assign ioenb = (adr[23:6] == 18'h3FFFF);
assign be0 = (ben & adr[0]);
assign be1 = (ben & ~adr[0]);
assign inbus = (~ioenb ? inbus0 : ((iowadr == 0) ? cnt1 : ((iowadr == 1) ? {20'h0, btn, swi} : ((iowadr == 2) ? {24'h0, dataRx} : ((iowadr == 3) ? {30'h0, rdyTx, rdyRx} : ((iowadr == 4) ? spiRx : ((iowadr == 5) ? {31'h0, spiRdy} : ((iowadr == 6) ? {3'h0, rdyKbd, dataMs} : ((iowadr == 7) ? {24'h0, dataKbd} : ((iowadr == 8) ? {24'h0, gpin} : ((iowadr == 9) ? {24'h0, gpoc} : 32'h0)))))))))));
assign codebus = ((adr[23:14] == 10'h3FF) ? romout : inbus0);
assign dataTx = outbus[7:0];
assign doneRx = ((rd & ioenb) & (iowadr == 2));
assign startTx = ((wr & ioenb) & (iowadr == 2));
assign doneKbd = ((rd & ioenb) & (iowadr == 7));
assign limit = (cnt0 == 24999);
assign spiStart = ((wr & ioenb) & (iowadr == 4));
always @ (posedge CLK50M) begin clk <= ~clk;
end
always @ (posedge clk) begin rst <= (((cnt1[4:0] == 5'h0) & limit) ? ~btn[3] : rst);
bitrate <= (~rst ? 0 : (((wr & ioenb) & (iowadr == 3)) ? outbus[0] : bitrate));
Lreg <= (~rst ? 0 : (((wr & ioenb) & (iowadr == 1)) ? outbus[7:0] : Lreg));
cnt0 <= (limit ? 0 : (cnt0 + 1));
cnt1 <= (cnt1 + {31'h0, limit});
spiCtrl <= (~rst ? 0 : (((wr & ioenb) & (iowadr == 5)) ? outbus[3:0] : spiCtrl));
gpout <= (~rst ? 0 : (((wr & ioenb) & (iowadr == 8)) ? outbus[7:0] : gpout));
gpoc <= (~rst ? 0 : (((wr & ioenb) & (iowadr == 9)) ? outbus[7:0] : gpoc));
end
endmodule
