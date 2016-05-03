
module am_modulator(
	input  wire clk,
	input  wire [15:0]signal,
	input  wire [15:0]carrier,
	output wire [7:0]out
);

//modulate by multiplying useful signal on modulation freq sinusoida
reg signed [31:0]multiplied;
always @(posedge clk)
	multiplied <= $signed(signal) * $signed(carrier);

reg signed [15:0]multiplied_th; //top half
always @(posedge clk)
	multiplied_th <= multiplied[31:16];

//add modulation freq carrier to signal
reg signed [16:0]s_after_mod;
always @(posedge clk)
	s_after_mod <= ( ($signed(carrier)>>>1)+$signed(multiplied_th) );

//make unsigned
reg [16:0]after_mod;
always @(posedge clk)
	after_mod <= s_after_mod + 17'h10000;

assign out = after_mod[16:9];

endmodule
