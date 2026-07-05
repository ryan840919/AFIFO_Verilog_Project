`timescale 1ns/1ps

module _20260626_AFIFO_TB ();

reg wclk, rclk, wrst, rrst, winc, rinc;
reg [7:0] wdata;
wire [7:0] rdata;
wire wfull, walmostfull, rempty, ralmostempty;

_20260626_AFIFO #(
	.datawidth(8),
	.addrwidth(4)
) AFIFO (
	.wclk(wclk), .rclk(rclk),
	.wrst(wrst), .rrst(rrst),
	.winc(winc), .rinc(rinc),
	.wdata(wdata), .rdata(rdata),
	.wfull(wfull), .walmostfull(walmostfull),
	.rempty(rempty), .ralmostempty(ralmostempty)
);
	
initial begin
	wclk = 1'b0;
	rclk = 1'b0;
end

always #5 wclk = ~wclk;
always #7 rclk = ~rclk;

integer w = 0;
integer r = 0;

initial begin
	wrst = 1'b1;
	winc = 1'b0;
	wdata = 8'h00;
	
	#4 wrst = 1'b0;
	
	#8 wrst = 1'b1;
	
	#20
	while (w<20) begin
		@(negedge wclk) begin
			if (!wfull) begin
				winc = 1'b1;
				wdata = w;
				w = w + 1;
			end
			else begin
				winc = 1'b0;
			end
		end
	end
	
	@(negedge wclk) //這裡要記得把winc條回0, 但要流一個週期再回來
		winc = 1'b0;
	
end

initial begin
	rrst = 1'b1;
	rinc = 1'b0;
	
	#4 rrst = 1'b0;
	
	#8 rrst = 1'b1;
	
	#300
	while (r<20) begin
		@(negedge rclk) begin
			if (!rempty) begin
				rinc = 1'b1;
				r = r + 1;
			end
			else begin
				rinc = 1'b0;
			end
		end
	end
	
	@(negedge rclk) //這裡要記得把rinc條回0, 但要流一個週期再回來
		rinc = 1'b0;
	
	#100 //這裡要記得把stop, 但要流時間觀察波形
	$stop;
	
end

endmodule
	
