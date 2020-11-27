`timescale 1ns/1ps

module tb_edge_detection (

);

//1080P
parameter	H_FRONT	=	88;
parameter	H_SYNC	=	44;
parameter	H_BACK	=	148;
parameter	H_ACT		=	1920;
parameter	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
parameter	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;

parameter	V_FRONT	=	4;
parameter	V_SYNC	=	5;
parameter	V_BACK	=	36;
parameter	V_ACT		=	1080;
parameter	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
parameter	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;



logic clk, reset_n;
logic hdmi_vsync, hdmi_hsync, hdmi_de;
logic [23:0] hdmi_data;
integer h_verify, v_verify;

logic edge_vsync, edge_hsync, edge_de;
logic [23:0] edge_data;

integer h_cnt, v_cnt, clk_cnt;

assign hdmi_de = (v_cnt >= V_FRONT+V_SYNC) && (v_cnt < V_TOTAL-V_BACK) &&
					  (h_cnt >= H_FRONT+H_SYNC) && (h_cnt < H_TOTAL-H_BACK) &&
					  hdmi_vsync && hdmi_hsync;



initial begin
	clk = 0;
	
	forever #3 clk = ~ clk;
end

initial begin
	reset_n = 0;
	
	#50 reset_n = 1;
end



edge_detection edge_detection_u0(
	.clk(clk),
	.reset_n(reset_n),
	
	.hdmi_de(hdmi_de),
	.hdmi_vsync(hdmi_vsync),
	.hdmi_hsync(hdmi_hsync),
	.hdmi_data_in(hdmi_data),
	
	.edge_de(edge_de),
	.edge_vsync(edge_vsync),
	.edge_hsync(edge_hsync),
	.edge_data_out(edge_data)
);



//Generate HDMI Hsync
always@(posedge clk or negedge reset_n)begin
	if(!reset_n) begin
		h_cnt <= 0;
		hdmi_hsync <= 1;
	end else begin
		if(h_cnt < H_TOTAL) h_cnt	<=	h_cnt + 1'b1;
		else h_cnt	<=	0;
		
		if(h_cnt == H_FRONT-1) hdmi_hsync <= 1'b0;
		
		if(h_cnt == H_FRONT+H_SYNC-1) hdmi_hsync <= 1'b1;
	end
end



//Generate HDMI Vsync
always@(posedge hdmi_hsync or negedge reset_n) begin
	if(!reset_n) begin
		v_cnt <= 0;
		hdmi_vsync <= 1;
	end else begin
		if(v_cnt < V_TOTAL) v_cnt <= v_cnt + 1'b1;
		else v_cnt <= 0;

		if(v_cnt == V_FRONT-1) hdmi_vsync <= 1'b0;
		
		if(v_cnt == V_FRONT+V_SYNC-1) hdmi_vsync <= 1'b1;
	end
end



//For testing
always @ (posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		h_verify <= 0;
	end else begin
		if (hdmi_de) begin
			h_verify <= h_verify + 1;
		end else begin
			h_verify <= 0;
		end
	end
end



//For testing
always @ (posedge hdmi_de or negedge reset_n) begin
	if (!reset_n) begin
		v_verify <= 0;
	end else begin
		v_verify <= v_verify + 1;
	end
end



//For testing
always @ (posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		clk_cnt <= 0;
	end else begin
		clk_cnt <= clk_cnt + 1;
	end
end



//For testing
always @ (posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		hdmi_data <= 0;
	end else begin
		hdmi_data <= v_cnt * h_cnt * clk_cnt;
	end
end


endmodule
