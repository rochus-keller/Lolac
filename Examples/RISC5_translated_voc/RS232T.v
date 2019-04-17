`timescale 1ns / 1 ps
module RS232T(   // translated from Lola
input clk, rst, start, fsel,
input [7:0] data,
output rdy, TxD);
reg run;
reg [11:0] tick;
reg [3:0] bitcnt;
reg [8:0] shreg;
wire endtick, endbit;
wire [11:0] limit;
assign rdy = ~run;
assign TxD = shreg[0];
assign endtick = (tick == limit);
assign endbit = (bitcnt == 9);
assign limit = (fsel ? 217 : 1302);
always @ (posedge clk) begin run <= ((~rst | (endtick & endbit)) ? 0 : (start ? 1 : run));
tick <= ((run & ~endtick) ? (tick + 1) : 0);
bitcnt <= ((endtick & ~endbit) ? (bitcnt + 1) : ((endtick & endbit) ? 4'h0 : bitcnt));
shreg <= (~rst ? 1 : (start ? {data, 1'h0} : (endtick ? {1'h1, shreg[8:1]} : shreg)));
end
endmodule
