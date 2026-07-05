module ReadCtrl #(
	parameter addrwidth = 4
)(
	input rclk, rinc, rrst,
	input [addrwidth:0] wptr_gray,
	output reg [addrwidth:0] rptr_gray,
	output [addrwidth-1:0] raddr,
	output ren, rempty, ralmostempty
);


reg [addrwidth:0] rptr_bin;
reg [addrwidth:0] rptrnext_bin;
wire [addrwidth:0] rptrnext_gray;

Bin2Gray #(.codewidth(addrwidth+1)) rptrb2g (.bincode(rptrnext_bin),.graycode(rptrnext_gray));

assign ren = rinc && (!rempty);
assign rempty = (wptr_gray == rptr_gray);
assign ralmostempty = (wptr_gray == rptrnext_gray);
assign raddr = rptr_bin[addrwidth-1:0];

always @(posedge rclk, negedge rrst) begin
	if (!rrst) begin
		rptr_bin <= {(addrwidth+1){1'b0}};
		rptrnext_bin <= {(addrwidth+1){1'b0}} + 1'b1;
		rptr_gray <= {(addrwidth+1){1'b0}};
	end
	else if (rinc && (!rempty)) begin
		rptr_bin <= rptr_bin + 1'b1;
		rptrnext_bin <= rptrnext_bin + 1'b1;
		rptr_gray <= rptrnext_gray;
	end
end

endmodule