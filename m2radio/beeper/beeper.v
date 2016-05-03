
module beeper(
	input wire clk96mhz,
	input wire key0,
	input wire key1,
	output wire [7:0]beep //modulated beep
);

reg [31:0]cnt;
always @(posedge clk96mhz)
	cnt<=cnt+1'b1;
	
wire [5:0]cnt_a; assign cnt_a = cnt[5:0];
wire [5:0]cnt_b; assign cnt_b = key1 ? cnt[15:10] : cnt[16:11];
wire x; assign x = key0 ? cnt[25] : cnt[26];

wire [15:0]sa;
wire [15:0]sb;
sin_tbl sin_tbl_inst(
	.address_a(cnt_a),
	.address_b(cnt_b),
	.clock(clk96mhz),
	.q_a(sa),
	.q_b(sb)
);

wire [7:0]out;
am_modulator am_modulator_inst(
	.clk(clk96mhz),
	.signal( x ? 0 : sb ),
	.carrier(sa),
	.out(out)
);

assign beep = out[7:0];

endmodule
