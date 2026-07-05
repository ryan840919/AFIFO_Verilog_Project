module _20260626_AFIFO #(
	parameter datawidth = 8,
	parameter addrwidth = 4
)(
	input [datawidth-1:0] wdata,
	input wclk, wrst, rclk, rrst, winc, rinc,
	output [datawidth-1:0] rdata,
	output wfull, walmostfull, rempty, ralmostempty
);

wire [addrwidth-1:0] waddr, raddr;
wire [addrwidth:0] wptr_gray_wclk, wptr_gray_rclk;
wire [addrwidth:0] rptr_gray_wclk, rptr_gray_rclk;
wire wen, ren;

FIFOMem #(
	.addrwidth(addrwidth),.datawidth(datawidth)
) AFIFOMem (
	.wclk(wclk),.rclk(rclk),
	.wdata(wdata),.rdata(rdata),
	.waddr(waddr),.raddr(raddr),
	.wen(wen),.ren(ren)
);

WriteCtrl #(
	.addrwidth(addrwidth)
) AFIFOWriteCtrl (
	.wclk(wclk),.winc(winc),.wrst(wrst),
	.waddr(waddr),.wptr_gray(wptr_gray_wclk),.rptr_gray(rptr_gray_wclk),
	.wen(wen),.wfull(wfull),.walmostfull(walmostfull)
);

ReadCtrl #(
	.addrwidth(addrwidth)
) AFIFOReadCtrl (
	.rclk(rclk),.rinc(rinc),.rrst(rrst),
	.raddr(raddr),.wptr_gray(wptr_gray_rclk),.rptr_gray(rptr_gray_rclk),
	.ren(ren),.rempty(rempty),.ralmostempty(ralmostempty)
);

CDC #(
	.signalwidth(addrwidth+1)
) w2rCDC (
	.clk(rclk),.rst(rrst),
	.insignal(wptr_gray_wclk),.outsignal(wptr_gray_rclk)
);

CDC #(
	.signalwidth(addrwidth+1)
) r2wCDC (
	.clk(wclk),.rst(wrst),
	.insignal(rptr_gray_rclk),.outsignal(rptr_gray_wclk)
);

endmodule