module Bin2Gray #(
	parameter codewidth = 5
)(
	input [codewidth-1:0] bincode,
//	output reg [codewidth-1:0] graycode
	output [codewidth-1:0] graycode
);

//always @(*) begin : b2g
//	integer i;
//	graycode[codewidth-1] = bincode[codewidth-1];
//	for (i=0; i<=(codewidth-2); i=i+1) begin
//		graycode[i] = bincode[i] xor bincode[i+1];
//	end
//end

assign graycode = bincode ^ (bincode>>1);

endmodule