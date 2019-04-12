`timescale 1ns / 1 ps
module VID(   // translated from Lola
input clk, inv,
input [31:0] viddata,
output req,
output [17:0] vidadr,
output hsync, vsync,
output [2:0] RGB);
wire hend, vend, vblank, xfer, vid, pclk;
reg [10:0] hcnt;
reg [9:0] vcnt;
reg hblank;
reg [31:0] pixbuf, vidbuf;
??? req1;
??? [4:0] hword;
assign req = req1;
assign vidadr = (229312 + {3'h0, ~vcnt, hword});
assign hsync = ~((hcnt >= 1086) & (hcnt <  1190));
assign vsync = ((vcnt >= 771) & (vcnt <  776));
assign RGB = {vid, vid, vid};
assign hend = (hcnt == 1343);
assign vend = (vcnt == 801);
assign vblank = (vcnt[8] & vcnt[9]);
assign xfer = (hcnt[4:0] == 5'h6);
assign vid = (((pixbuf[0] ^ inv) & ~hblank) & ~vblank);
DCMX3 dcmx3(.CLKIN(clk), .CLKFX(pclk));
always @ (posedge pclk) begin hcnt <= (hend ? 0 : (hcnt + 1));
vcnt <= (hend ? (vend ? 0 : (vcnt + 1)) : vcnt);
hblank <= (xfer ? hcnt[10] : hblank);
pixbuf <= (xfer ? vidbuf : {1'h0, pixbuf[31:1]});
vidbuf <= (req ? viddata : vidbuf);
end
endmodule
