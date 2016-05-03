
///////////////////////////////////////////////////////////////
//module which generates video sync impulses
///////////////////////////////////////////////////////////////

module hvsync (
	// inputs:
	input wire pixel_clock,

	// outputs:
	output reg hsync,
	output reg vsync,

	//high-color test video signal
	output reg [4:0]r,
	output reg [5:0]g,
	output reg [4:0]b
	);
	
	// video signal parameters, default 1440x900 60Hz
	parameter horz_front_porch = 80;
	parameter horz_sync = 152;
	parameter horz_back_porch = 232;
	parameter horz_addr_time = 1440;
	
	parameter vert_front_porch = 3;
	parameter vert_sync = 6;
	parameter vert_back_porch = 25;
	parameter vert_addr_time = 900;
	
	//variables	
	reg [11:0]pixel_count = 0;
	reg [11:0]line_count = 0;

reg hvisible = 1'b0;
reg vvisible = 1'b0;

//synchronous process
always @(posedge pixel_clock)
begin
	hsync <= (pixel_count < horz_sync);
	hvisible <= (pixel_count >= (horz_sync+horz_back_porch)) && 
		(pixel_count < (horz_sync+horz_back_porch+horz_addr_time));
	
	if(pixel_count < (horz_sync+horz_back_porch+horz_addr_time+horz_front_porch) )
		pixel_count <= pixel_count + 1'b1;
	else
		pixel_count <= 0;
end

always @(posedge hsync)
begin
	vsync <= (line_count < vert_sync);
	vvisible <= (line_count >= (vert_sync+vert_back_porch)) && 
		(line_count < (vert_sync+vert_back_porch+vert_addr_time));
	
	if(line_count < (vert_sync+vert_back_porch+vert_addr_time+vert_front_porch) )
		line_count <= line_count + 1'b1;
	else
		line_count <= 0;
end

wire visible; assign visible = hvisible & vvisible;
wire rvisible; assign rvisible = pixel_count[6];
wire gvisible; assign gvisible = pixel_count[7];
wire bvisible; assign bvisible = pixel_count[8];

always @*
begin
	if(visible & rvisible)
		r = pixel_count[5:1];
	else
		r = 0;

		if(visible & gvisible)
		g = pixel_count[5:0];
	else
		g = 0;

	if(visible & bvisible)
		b = pixel_count[5:1];
	else
		b = 0;
end

endmodule

