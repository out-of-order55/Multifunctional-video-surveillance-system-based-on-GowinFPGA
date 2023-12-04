`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/08 14:22:44
// Design Name: 
// Module Name: couper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//裁剪

//输入均为couper的输出数据(时钟同步),对于输出而言,将各路fifo的数据分时读出(具体根据行列计数为每一路设置都市能,写使能均为href)

module couper #(
	parameter IW 		= 640	,
	parameter IH 		= 480	,	
	parameter DW 		= 8		,	
	parameter COUPER_W 	= 256	,
	parameter COUPER_V 	= 256	,
	parameter HL_ZONE 	= 192	,	//裁剪区域左边界
	parameter VU_ZONE 	= 112       //裁剪区域上边界

)
(
	input					clk				,
	input           		rst_n			,
	
	input   				per_vs			,		
	input   				per_de			,		
	input 		[DW-1:0]   	per_data		,
	input					pre_data_en		,
	output	reg				post_data_en	,
	output	reg				post_pre_de		,			
	output reg  			post_vs			,	
	output reg   			post_de			,		
	output reg 	[DW-1:0] 	post_data
);
	
localparam HR_ZONE = HL_ZONE + COUPER_W,
           VD_ZONE = VU_ZONE + COUPER_V;	
		  
		  
reg	 		per_vs_r	;
wire		pose		;
	
reg [15:0] 	hcnt		;
reg [15:0] 	vcnt		;			  	  			
always@(posedge clk)	
	if(!rst_n)
		per_vs_r <= 1'b0;
	else 
		per_vs_r <= per_vs;

assign pose = ~per_vs_r&&per_vs	;
	
always@(posedge clk)	
	if(!rst_n)
		hcnt <= 'd0;
	else if(per_de==1'b1)
		hcnt <= hcnt + 1'b1;
	else
		hcnt <= 'd0;

always@(posedge clk)	
	if(!rst_n)
		vcnt <= 'd0;
	else if(pose==1'b1)
		vcnt <= 'd0;
	else if(hcnt==IW-1&&vcnt==IH-1)
		vcnt <= 'd0;
	else if(hcnt==IW-1)
		vcnt <= vcnt + 1'b1;
	else
		vcnt <= vcnt;

// couper_fifo couper_fifo_u(
// 		.Data(per_data), //input [15:0] Data
// 		.Clk(clk), //input Clk
// 		.WrEn(wr_en), //input WrEn
// 		.RdEn(rd_en), //input RdEn
// 		.Reset(~rst_n), //input Reset
// 		.Q(data_o), //output [15:0] Q
// 		.Empty(), //output Empty
// 		.Full() //output Full
// );
wire[15:0]	data_o;
wire		wr_en=hcnt>=HL_ZONE&&hcnt<HR_ZONE&&per_de;
wire		rd_en=hcnt<=HL_ZONE&&hcnt>=HR_ZONE&&vcnt<=VU_ZONE&&vcnt>=VD_ZONE&&per_de;
always@(posedge clk)	
	if(!rst_n)
		post_data <= 'd0;
	else if(hcnt>=HL_ZONE&&hcnt<HR_ZONE&&vcnt>=VU_ZONE&&vcnt<VD_ZONE&&per_de)
		post_data <= per_data;	  
	else
		post_data <='hdd;

always@(posedge clk)	
	if(!rst_n)
		post_pre_de<=1'b0;
	else
		post_pre_de<=per_de;
always@(posedge clk)	
	if(!rst_n)
		post_de <= 1'b0;
	else if(hcnt>=HL_ZONE&&hcnt<HR_ZONE&&vcnt>=VU_ZONE&&vcnt<VD_ZONE&&per_de)
		post_de <= 1'b1;
	else
		post_de <=1'b0;		
		
always@(posedge clk)	
	if(!rst_n)
		post_vs <= 'd0;
	else 
		post_vs <= per_vs;
always@(posedge clk)	
	if(!rst_n)
		post_data_en<=1'b0;
	else	
		post_data_en<=pre_data_en;		
endmodule
