module WriteCtrl #(
	parameter addrwidth = 4
)(
	input wclk, winc, wrst,
	input [addrwidth:0] rptr_gray,
	output reg [addrwidth:0] wptr_gray,
	output [addrwidth-1:0] waddr,
	output wen, wfull, walmostfull
);

reg [addrwidth:0] wptr_bin;
reg [addrwidth:0] wptrnext_bin;
wire [addrwidth:0] wptrnext_gray;

assign wen = winc && (!wfull); // 非常重要!! 
assign waddr = wptr_bin[addrwidth-1:0];
assign wfull = (wptr_gray[addrwidth-2:0] == rptr_gray[addrwidth-2:0])
					&& (wptr_gray[addrwidth:addrwidth-1] == ~rptr_gray[addrwidth:addrwidth-1]);
assign walmostfull = (wptrnext_gray[addrwidth-2:0] == rptr_gray[addrwidth-2:0])
							&& (wptrnext_gray[addrwidth:addrwidth-1] == ~rptr_gray[addrwidth:addrwidth-1]);

//Bin2Gray #(.codewidth(addrwidth+1)) wptrb2g (.bincode(wptr_bin),.graycode(wptr_gray));
Bin2Gray #(.codewidth(addrwidth+1)) wptrnextb2g (.bincode(wptrnext_bin),.graycode(wptrnext_gray));

always @(posedge wclk, negedge wrst) begin
	if (!wrst) begin
		wptr_bin <= {(addrwidth+1){1'b0}};
		wptrnext_bin <= {(addrwidth+1){1'b0}} + 1'b1;
		wptr_gray <= {(addrwidth+1){1'b0}}; // 要記得reset
	end
	else if (winc && (!wfull)) begin
		wptr_bin <= wptr_bin + 1'b1;
		wptrnext_bin <= wptrnext_bin + 1'b1;
		wptr_gray <= wptrnext_gray;	// 非常重要!! 正在消化
	end
end

endmodule
