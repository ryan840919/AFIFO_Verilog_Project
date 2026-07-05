module CDC #(
	parameter signalwidth = 5
)(
	input clk, rst,
	input [signalwidth-1:0] insignal,
	output reg [signalwidth-1:0] outsignal
);

reg [signalwidth-1:0] middff;

//always @(posedge clk, negedge rst) begin : cdcdff
//	integer i;
//	for (i = 0; i <= (signalwidth-1); i = i + 1) begin
//		if (!rst) begin
//			middff[i] <= 1'b0;
//			outsignal[i] <= 1'b0;
//		end
//		else begin
//			middff[i] <= insignal[i];
//			outsignal[i] <= middff[i];
//		end
//	end
//end

always @(posedge clk, negedge rst) begin
	if (!rst) begin
		middff <= {signalwidth{1'b0}};
		outsignal <= {signalwidth{1'b0}};
	end
	else begin
		middff <= insignal;
		outsignal <= middff;
	end
end

endmodule