
module cyclone_v_edge_detection(
	//////////// CLOCK //////////
	input 		          		FPGA_CLK1_50,
	input 		          		FPGA_CLK2_50,
	input 		          		FPGA_CLK3_50,

	//////////// HDMI //////////
	inout 		          		HDMI_I2C_SCL,
	inout 		          		HDMI_I2C_SDA,
	inout 		          		HDMI_I2S,
	inout 		          		HDMI_LRCLK,
	inout 		          		HDMI_MCLK,
	inout 		          		HDMI_SCLK,
	output		          		HDMI_TX_CLK,
	output		reg          	HDMI_TX_DE,
	output		reg  [23:0]		HDMI_TX_D,
	output		reg        		HDMI_TX_HS,
	input 		          		HDMI_TX_INT,
	output		reg        		HDMI_TX_VS,

	//////////// HPS //////////
	inout 		          		HPS_CONV_USB_N,
	output		    [14:0]		HPS_DDR3_ADDR,
	output		     [2:0]		HPS_DDR3_BA,
	output		          		HPS_DDR3_CAS_N,
	output		          		HPS_DDR3_CKE,
	output		          		HPS_DDR3_CK_N,
	output		          		HPS_DDR3_CK_P,
	output		          		HPS_DDR3_CS_N,
	output		     [3:0]		HPS_DDR3_DM,
	inout 		    [31:0]		HPS_DDR3_DQ,
	inout 		     [3:0]		HPS_DDR3_DQS_N,
	inout 		     [3:0]		HPS_DDR3_DQS_P,
	output		          		HPS_DDR3_ODT,
	output		          		HPS_DDR3_RAS_N,
	output		          		HPS_DDR3_RESET_N,
	input 		          		HPS_DDR3_RZQ,
	output		          		HPS_DDR3_WE_N,
	output		          		HPS_ENET_GTX_CLK,
	inout 		          		HPS_ENET_INT_N,
	output		          		HPS_ENET_MDC,
	inout 		          		HPS_ENET_MDIO,
	input 		          		HPS_ENET_RX_CLK,
	input 		     [3:0]		HPS_ENET_RX_DATA,
	input 		          		HPS_ENET_RX_DV,
	output		     [3:0]		HPS_ENET_TX_DATA,
	output		          		HPS_ENET_TX_EN,
	inout 		          		HPS_GSENSOR_INT,
	inout 		          		HPS_I2C0_SCLK,
	inout 		          		HPS_I2C0_SDAT,
	inout 		          		HPS_I2C1_SCLK,
	inout 		          		HPS_I2C1_SDAT,
	inout 		          		HPS_KEY,
	inout 		          		HPS_LED,
	inout 		          		HPS_LTC_GPIO,
	output		          		HPS_SD_CLK,
	inout 		          		HPS_SD_CMD,
	inout 		     [3:0]		HPS_SD_DATA,
	output		          		HPS_SPIM_CLK,
	input 		          		HPS_SPIM_MISO,
	output		          		HPS_SPIM_MOSI,
	inout 		          		HPS_SPIM_SS,
	input 		          		HPS_UART_RX,
	output		          		HPS_UART_TX,
	input 		          		HPS_USB_CLKOUT,
	inout 		     [7:0]		HPS_USB_DATA,
	input 		          		HPS_USB_DIR,
	input 		          		HPS_USB_NXT,
	output		          		HPS_USB_STP,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [7:0]		LED,

	//////////// SW //////////
	input 		     [3:0]		SW,
	
	//OV5642
	output							OV5642_SCL,
	inout								OV5642_SDA,
	input								OV5642_VSYNC,
	input								OV5642_HREF,
	input								OV5642_PCLK,
	output							OV5642_XCLK,
	input				  [9:0]		OV5642_DATA,
	output							OV5642_PWDN
);



parameter VIDEO_HEIGHT = 16'd1080; 
parameter VIDEO_WIDTH  = 16'd1920; 



wire        ov5642_vsync, ov5642_hsync, ov5642_pclk;
wire  [9:0] ov5642_data;

wire			normal_vsync, normal_hsync, normal_de;
wire [23:0] normal_video_data;

wire			edge_vsync, edge_hsync, edge_de;
wire [23:0] edge_video_data;


reg 	[31:0]	delay_count;
localparam		delay = 5000000; //delay 100ms
reg ov5642_pwdn_control;


assign LED[0] = 1'b1;
assign LED[1] = HDMI_TX_CLK;
assign LED[2] = HDMI_TX_DE;
assign LED[3] = HDMI_TX_VS;
assign LED[4] = HDMI_TX_HS;
assign LED[5] = HDMI_TX_HS;

assign LED[7] = SW[0];

assign OV5642_PWDN = ov5642_pwdn_control;



soc_system u0 (
	//Clock&Reset
	.clk_clk                               ( FPGA_CLK3_50 ),                               //                            clk.clk
   .clk_hps_ref_clk                       (FPGA_CLK1_50),                             //                   pll_1_refclk.clk
   .clk_hdmi_ref_clk                      (FPGA_CLK2_50), 
	.reset_reset_n                         (1'b1),         

	//HPS ddr3
	.memory_mem_a                          ( HPS_DDR3_ADDR),                       //                memory.mem_a
	.memory_mem_ba                         ( HPS_DDR3_BA),                         //                .mem_ba
	.memory_mem_ck                         ( HPS_DDR3_CK_P),                       //                .mem_ck
	.memory_mem_ck_n                       ( HPS_DDR3_CK_N),                       //                .mem_ck_n
	.memory_mem_cke                        ( HPS_DDR3_CKE),                        //                .mem_cke
	.memory_mem_cs_n                       ( HPS_DDR3_CS_N),                       //                .mem_cs_n
	.memory_mem_ras_n                      ( HPS_DDR3_RAS_N),                      //                .mem_ras_n
	.memory_mem_cas_n                      ( HPS_DDR3_CAS_N),                      //                .mem_cas_n
	.memory_mem_we_n                       ( HPS_DDR3_WE_N),                       //                .mem_we_n
	.memory_mem_reset_n                    ( HPS_DDR3_RESET_N),                    //                .mem_reset_n
	.memory_mem_dq                         ( HPS_DDR3_DQ),                         //                .mem_dq
	.memory_mem_dqs                        ( HPS_DDR3_DQS_P),                      //                .mem_dqs
	.memory_mem_dqs_n                      ( HPS_DDR3_DQS_N),                      //                .mem_dqs_n
	.memory_mem_odt                        ( HPS_DDR3_ODT),                        //                .mem_odt
	.memory_mem_dm                         ( HPS_DDR3_DM),                         //                .mem_dm
	.memory_oct_rzqin                      ( HPS_DDR3_RZQ),             //                .oct_rzqin
	//HPS SD card
	.hps_0_hps_io_hps_io_sdio_inst_CMD     ( HPS_SD_CMD    ),           //                               .hps_io_sdio_inst_CMD
	.hps_0_hps_io_hps_io_sdio_inst_D0      ( HPS_SD_DATA[0]     ),      //                               .hps_io_sdio_inst_D0
	.hps_0_hps_io_hps_io_sdio_inst_D1      ( HPS_SD_DATA[1]     ),      //                               .hps_io_sdio_inst_D1
	.hps_0_hps_io_hps_io_sdio_inst_CLK     ( HPS_SD_CLK   ),            //                               .hps_io_sdio_inst_CLK
	.hps_0_hps_io_hps_io_sdio_inst_D2      ( HPS_SD_DATA[2]     ),      //                               .hps_io_sdio_inst_D2
	.hps_0_hps_io_hps_io_sdio_inst_D3      ( HPS_SD_DATA[3]     ),      //                               .hps_io_sdio_inst_D3
	//HPS UART
	.hps_0_hps_io_hps_io_uart0_inst_RX     ( HPS_UART_RX   ),          //                               .hps_io_uart0_inst_RX
	.hps_0_hps_io_hps_io_uart0_inst_TX     ( HPS_UART_TX   ),          //                               .hps_io_uart0_inst_TX
	.hps_0_hps_io_hps_io_gpio_inst_GPIO53  ( HPS_LED   ),  //                               .hps_io_gpio_inst_GPIO53

	//D8M camera
	.terasic_camera_0_conduit_end_camera_d        ({ov5642_data[9:0], 2'b00}),               //   terasic_camera_0_conduit_end.D
	.terasic_camera_0_conduit_end_camera_fval     (!ov5642_vsync),            //                               .FVAL
	.terasic_camera_0_conduit_end_camera_lval     (ov5642_hsync),            //                               .LVAL
	.terasic_camera_0_conduit_end_camera_pixclk   (ov5642_pclk),           //                               .PIXCLK
   
	//FPGA Partion
   .alt_vip_itc_0_clocked_video_vid_clk          (HDMI_TX_CLK),          //    alt_vip_itc_0_clocked_video.vid_clk
   .alt_vip_itc_0_clocked_video_vid_data         (normal_video_data),         //                               .vid_data
   .alt_vip_itc_0_clocked_video_vid_datavalid    (normal_de),    //                               .vid_datavalid
   .alt_vip_itc_0_clocked_video_vid_v_sync       (normal_vsync),       //                               .vid_v_sync
   .alt_vip_itc_0_clocked_video_vid_h_sync       (normal_hsync),       //                               .vid_h_sync

	//clk for HDMI_TX_CLK
	.clk_hdmi_clk                                 (HDMI_TX_CLK),
	//clk for MIPI_REFCLK
	.clk_cam_clk                                  (OV5642_XCLK)                                  //                        clk_d8m.clk
);
	


//OV5642 I2C
I2C_OV5642_Config #(.NUM_BYTE(3), .SLAVE_ADDR(8'h78)) I2C_OV5642_Config_u0 (
	.iCLK(FPGA_CLK3_50),
	.iRST_N(!OV5642_PWDN),
	.I2C_SCLK(OV5642_SCL),
	.I2C_SDAT(OV5642_SDA),
	.HDMI_TX_INT(HDMI_TX_INT),
	.READY()
);



//HDMI I2C
I2C_HDMI_Config u_I2C_HDMI_Config (
	.iCLK(FPGA_CLK2_50),
	.iRST_N(!ov5642_pwdn_control),
	.I2C_SCLK(HDMI_I2C_SCL),
	.I2C_SDAT(HDMI_I2C_SDA),
	.HDMI_TX_INT(HDMI_TX_INT)
);



//Edge detection
edge_detection edge_detection_u0(
	.clk(HDMI_TX_CLK),
	.reset_n(!ov5642_pwdn_control),
	
	.hdmi_de(normal_de),
	.hdmi_vsync(normal_vsync),
	.hdmi_hsync(normal_hsync),
	.hdmi_data_in(normal_video_data),
	
	.edge_de(edge_de),
	.edge_vsync(edge_vsync),
	.edge_hsync(edge_hsync),
	.edge_data_out(edge_video_data)
);



//Video source select
always @ (posedge HDMI_TX_CLK) begin
	if (SW[0]) begin
		HDMI_TX_DE <= edge_de;
		HDMI_TX_D <= edge_video_data;
		HDMI_TX_HS <= edge_hsync;
		HDMI_TX_VS <= edge_vsync;
	end else begin
		HDMI_TX_DE <= normal_de;
		HDMI_TX_D <= normal_video_data;
		HDMI_TX_HS <= normal_hsync;
		HDMI_TX_VS <= normal_vsync;
	end
end



//Buffer for OV5642 signal
buffer_iobuf_in_i2i buffer_u0( 
	.datain({OV5642_DATA, OV5642_VSYNC, OV5642_HREF, OV5642_PCLK}),
	.dataout({ov5642_data, ov5642_vsync, ov5642_hsync, ov5642_pclk})
);



//OV5642 power up delay
always @ (posedge FPGA_CLK3_50) begin
	if (delay_count >= delay) begin
		ov5642_pwdn_control <= 1'b0;
	end else begin
		ov5642_pwdn_control <= 1'b1;
		delay_count <= delay_count + 1'b1;
	end
end



endmodule



//for testbench
//module DE10_Nano_D8M_DDR3 (
//	input	clk,
//	
//	output test
//);
//
//assign test = clk;
//
//endmodule
