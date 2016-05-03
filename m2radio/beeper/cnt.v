
module cnt(
	input  wire clk,
	output wire [20:0] o1,
	output wire [20:0] o2
);

reg [15:0]a;
reg [15:0]b;

always @(posedge clk)
begin
	a<=a+1;
	b<= a[0] ? 16'haa55 : 16'hbb66;
end

assign o1 = { a, 4'b0000 };
assign o2 = { b, 4'b0000 };

endmodule
