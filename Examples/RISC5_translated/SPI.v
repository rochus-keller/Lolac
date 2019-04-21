`timescale 1ns / 1 ps
module SPI(   // translated from Lola
input clk, rst, start, fast,
input [31:0] dataTx,
output [31:0] dataRx,
output rdy,
input MISO,
output MOSI, SCLK);
reg rdyR;
reg [31:0] shreg;
reg [5:0] tick;
reg [4:0] bitcnt;
wire endbit, endtick;
assign dataRx = (fast ? shreg : {24'h0, shreg[7:0]});
assign rdy = rdyR;
assign MOSI = ((~rst | rdyR) ? 1 : shreg[7]);
assign SCLK = ((~rst | rdyR) ? 1 : (fast ? tick[0] : tick[5]));
assign endbit = (fast ? (bitcnt == 31) : (bitcnt == 7));
assign endtick = (fast ? (tick == 1) : (tick == 63));
always @ (posedge clk) begin rdyR <= ((~rst | (endtick & endbit)) | (~start & rdyR));
shreg <= (~rst ? 32'hFFFFFFFF : (start ? dataTx : (endtick ? {shreg[30:24], MISO, shreg[22:16], shreg[31], shreg[14:8], shreg[23], shreg[6:0], (fast ? shreg[15] : MISO)} : shreg)));
tick <= (((~rst | rdyR) | endtick) ? 0 : (tick + 1));
bitcnt <= ((~rst | start) ? 0 : ((endtick & ~endbit) ? (bitcnt + 1) : bitcnt));
end
endmodule
