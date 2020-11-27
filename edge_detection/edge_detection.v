
module edge_detection (
	input						clk,
	input						reset_n,
	
	input						hdmi_de,
	input						hdmi_vsync,
	input						hdmi_hsync,
	input		[23:0]		hdmi_data_in,
	
	output	reg			edge_de,
	output	reg			edge_vsync,
	output	reg			edge_hsync,
	output	reg [23:0]	edge_data_out
);



reg edge_de_0, edge_vsync_0, edge_hsync_0;



//Sobel filter for edge detection
wire [11:0] y_value;
wire signed [11:0] gx, gy;
wire [23:0] g_sum;
wire [11:0] y_result;
wire [11:0] line0, line1, line2;

reg	[11:0] D[8:0];

assign y_value = 5*hdmi_data_in[23:16] + 9*hdmi_data_in[15:8] + 2*hdmi_data_in[7:0];

// Gx matrix      Gy matrix
// -1  0  1       -1  -2  -1
// -2  0  2        0   0   0
// -1  0  1        1   2   1
assign gx = (D[2] - D[0]) + (D[5] - D[3]) + (D[8] - D[6]);
assign gy = (D[6] - D[0]) + (D[7] - D[1]) + (D[8] - D[2]);

assign g_sum = gx*gx + gy*gy;



//sqrt for sobel filter result
sqrt sqrt_u0(
	.radical(g_sum),
	.q(y_result),
	.remainder()
);


//Shift register for data input						
shift_register shift_register_u0(
	.aclr(!reset_n),
	.clken(hdmi_de),
	.clock(clk),
	.shiftin(y_value),
	.shiftout(),
	.taps0x(line0),
	.taps1x(line1),
	.taps2x(line2)
);



//Delay signal
always @ (posedge clk) begin
	edge_de_0 <= hdmi_de;
	edge_vsync_0 <= hdmi_vsync;
	edge_hsync_0 <= hdmi_hsync;
	
	edge_de <= edge_de_0;
	edge_vsync <= edge_vsync_0;
	edge_hsync <= edge_hsync_0;
end



//Generate output data
always @ (posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		edge_data_out <= 24'b0;
	end else begin
		if (y_result > 1300) edge_data_out <= {8'hFF, 8'hFF, 8'hFF};
		else edge_data_out <= {24'b0};
	end
end



//Generate 3x3 matrix
always @ (posedge clk) begin
	D[2] <= line0;
	D[1] <= D[2];
	D[0] <= D[1];
	
	D[5] <= line1;
	D[4] <= D[5];
	D[3] <= D[4];
	
	D[8] <= line2;
	D[7] <= D[8];
	D[6] <= D[7];		
end



endmodule
