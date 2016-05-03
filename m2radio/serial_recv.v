
module serial_recv(
	input wire sclk, //96MHz
	input wire sdata,
	output reg [31:0]tuner_freq,
	output wire [3:0]bits4 
);

parameter RCONST = 7; //12000000bps

reg [7:0]rx_byte0;
reg [7:0]rx_byte1;
reg [7:0]rx_byte2;
reg [7:0]rx_byte3;
reg [7:0]rx_byte4;
reg rbyte_ready;

//fix input serial RX data
reg [1:0]shr;
always @(posedge sclk)
	shr <= {shr[0],sdata};
wire rxf; assign rxf = shr[1];
wire rx_edge; assign rx_edge = shr[0]!=shr[1];

reg [3:0]cnt;
wire xbit; assign xbit = (cnt==RCONST || rx_edge);

reg [3:0]num_bits=0;
reg [7:0]shift_reg;

always @(posedge sclk)
begin
	if( xbit )
		cnt <= 0;
	else
	if(num_bits<9)
		cnt <= cnt + 1'b1;
end

always @(posedge sclk)
begin
	if(num_bits==9 && shr[0]==1'b0 )
		num_bits <= 0;
	else
	if( xbit )
		num_bits <= num_bits + 1'b1;
			
	if( cnt == RCONST/2 )
		shift_reg <= {rxf,shift_reg[7:1]};
end

reg [2:0]flag;
always @(posedge sclk)
		flag <= {flag[1:0],(num_bits==9)};

always @*
	rbyte_ready = (flag==3'b011);

always @(posedge sclk)
	if(rbyte_ready)
	begin
		rx_byte0 <= rx_byte1;
		rx_byte1 <= rx_byte2;
		rx_byte2 <= rx_byte3;
		rx_byte3 <= rx_byte4;
		rx_byte4 <= shift_reg[7:0];
	end

assign bits4 = rx_byte4[3:0];

always @(posedge sclk)
	if( rx_byte0[7] )
		tuner_freq <= {
				rx_byte0[4],rx_byte4[6:0],
				rx_byte0[2],rx_byte3[6:0],
				rx_byte0[1],rx_byte2[6:0],
				rx_byte0[0],rx_byte1[6:0]
			};

endmodule
