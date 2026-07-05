module FIFOMem #(
	parameter addrwidth = 4,
	parameter datawidth = 8
)(
	input wclk, rclk,
	input [addrwidth-1:0] waddr, raddr, 
	input wen, ren,
	input [datawidth-1:0] wdata,
	output reg [datawidth-1:0] rdata
);

(* ramstyle = "logic" *)reg [datawidth-1:0] mem [0:(1<<addrwidth)-1];
// 遇到一個dll的環境問題, 檔案似乎跟要implement成ram有關
//gemini說可以靠這個用DFF來合成 (會分寫入端跟讀取端)


always @(posedge wclk) begin
	if (wen == 1)
		mem[waddr] <= wdata;
end

always @(posedge rclk) begin
	if (ren == 1)
		rdata <= mem[raddr];
end

endmodule

