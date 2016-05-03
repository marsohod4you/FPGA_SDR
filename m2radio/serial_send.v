
module serial_send(
	input wire sclk, //12*8=96Mhz
	input wire sample_clk, //100kHz
	input wire [31:0]chan0,
	input wire [31:0]chan1,
	output wire odata //serial port output, 12Mbit, 8bit, 1stop, noparity
);

//actual sampling is 50kHz, so divide sample_clk on 2
//this is because FIR makes decimation on 2
reg sample_clk_2 = 1'b0;
always @(posedge sample_clk)
	sample_clk_2 <= ~sample_clk_2;

//make actual serial port frequency 12MHz (12Mbit/sec)
reg [2:0]cnt;
wire clk12mhz; assign clk12mhz=cnt[2];
always @(posedge sclk)
	cnt<=cnt+1'b1;

//cross domain clock from 100kHw to 12Mbit
//make 50kHz edge synchronized to 12MHz
reg [3:0]fsck;
always @(posedge clk12mhz)
	fsck <= { fsck[2:0],sample_clk_2 };
	
wire fsck_edge; assign fsck_edge = fsck[3:2]==2'b01;

//serial shift register
reg [119:0]sr;
always @(posedge clk12mhz)
	if(fsck_edge)
		sr<= {
		//|stop| byte--------------| start bit
			3'h7, 1'b0,chan1[30:24], 1'b0,
			3'h7, 1'b0,chan1[22:16], 1'b0,
			3'h7, 1'b0,chan1[14: 8], 1'b0,
			3'h7, 1'b0,chan1[ 6: 0], 1'b0,
			3'h7, 4'b0100,chan1[31],
							  chan1[23],
							  chan1[15],
							  chan1[7] , 1'b0,
		   3'h7, 1'b0,chan0[30:24], 1'b0,
			3'h7, 1'b0,chan0[22:16], 1'b0,
			3'h7, 1'b0,chan0[14: 8], 1'b0,
			3'h7, 1'b0,chan0[ 6: 0], 1'b0,
			3'h7, 4'b1000,chan0[31],
							  chan0[23],
							  chan0[15],
							  chan0[7] , 1'b0
			};
	else
		sr <= { 1'b1, sr[119:1] };

//serial output
assign odata = sr[0];

endmodule
