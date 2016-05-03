
module multiply(
	input  wire clk,
	input  wire	[7:0] adc_data,
	input  wire [9:0] fsin,
	input  wire [9:0] fcos,
	output reg signed [15:0] sin_o,
	output reg signed [15:0] cos_o
);

reg signed [7:0]data;
reg signed [7:0]fsin8;
reg signed [7:0]fcos8;

always @(posedge clk)
begin
	data <= adc_data-8'h80;
	fsin8 <= fsin[9:2];
	fcos8 <= fcos[9:2];
end

always @(posedge clk)
begin
	sin_o <= data * fsin8;
	cos_o <= data * fcos8;
end

endmodule
