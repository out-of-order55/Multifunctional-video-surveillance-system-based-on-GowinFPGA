`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/07 10:06:43
// Design Name: 
// Module Name: matrix
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


module matrix #(	
	parameter COL = 1280	,
    parameter ROW = 720	
)
(
	input 				clk			,
	input 				rst_n		,
	input               data_de		,
	input  	   [7:0] 	data		,
	input				data_en		,
	output				matrix_en	,
	output 	          	matrix_de	,

	output reg [7:0]	matrix11	,
	output reg [7:0]    matrix12	,
	output reg [7:0]    matrix13	,
	
	output reg [7:0]	matrix21	,
	output reg [7:0]    matrix22	,
    output reg [7:0]    matrix23	,
	
	output reg [7:0]	matrix31	,
	output reg [7:0]    matrix32	,
	output reg [7:0]    matrix33	
);

wire 	[7:0]  	row3_data	;                                                                                                           
wire 	[7:0]  	row2_data	;
wire 	[7:0]  	row1_data	;

reg  	[15:0]	col_cnt		;
reg  	[15:0]	row_cnt		;

wire			row2_rd		;

reg         	data_de_r	;
reg         	data_de_r1	;

reg				data_en_r	;
reg				data_en_r1	;

wire			u1_empty	;	
wire			u2_empty    ;

wire			wr_en		;

always@(posedge clk)
	if(!rst_n)	
		col_cnt <= 'd0;
	else if(col_cnt==COL-1)
		col_cnt <= 'd0;
	else if(data_de==1'b1)
		col_cnt <= col_cnt + 1'b1;
	else
		col_cnt <= col_cnt;

always@(posedge clk)
	if(!rst_n)	
		row_cnt <= 'd0;
	else if(col_cnt==COL-1&&row_cnt==ROW-1)
		row_cnt <= 'd0;
	else if(col_cnt==COL-1)
		row_cnt <= row_cnt + 1'b1;
	else
		row_cnt <= row_cnt;

assign wr_en = data_de&&row_cnt<ROW-1;
		
always@(posedge clk)
	if(!rst_n)	
		data_de_r <= 1'b0;
	else
		data_de_r <= data_de;

always@(posedge clk)
	if(!rst_n)	
		data_de_r1 <= 1'b0;
	else
		data_de_r1 <= data_de_r;

always@(posedge clk)
	if(!rst_n)	
		data_en_r <= 1'b0;
	else
		data_en_r <= data_en;

always@(posedge clk)
	if(!rst_n)	
		data_en_r1 <= 1'b0;
	else
		data_en_r1 <= data_en_r;

assign	matrix_en = data_en_r1  ;
assign  matrix_de = data_de_r1	;	
assign 	row3_data = data;


sync_fifo_u sync_fifo_u0(
		.Data(row3_data), //input [7:0] Data
		.Clk(clk), //input Clk
		.WrEn(wr_en), //input WrEn
		.RdEn(row2_rd), //input RdEn
		.Reset(~rst_n), //input Reset
		.Q(row2_data), //output [7:0] Q
		.Empty(u1_empty), //output Empty
		.Full() //output Full
	);
sync_fifo_u sync_fifo_u1(
		.Data(row2_data), //input [7:0] Data
		.Clk(clk), //input Clk
		.WrEn(wr_en), //input WrEn
		.RdEn(row2_rd), //input RdEn
		.Reset(~rst_n), //input Reset
		.Q(row1_data), //output [7:0] Q
		.Empty(u2_empty), //output Empty
		.Full() //output Full
	);
assign row2_rd =  data_de&&row_cnt>0;

always@(posedge clk)
	if(!rst_n)
		begin
			{matrix11, matrix12, matrix13} <= 24'd0;
			{matrix21, matrix22, matrix23} <= 24'd0;
			{matrix31, matrix32, matrix33} <= 24'd0;
		end
	else if(data_de==1'b1)
		begin
			{matrix11, matrix12, matrix13} <= {matrix12, matrix13, row1_data};
			{matrix21, matrix22, matrix23} <= {matrix22, matrix23, row2_data};
			{matrix31, matrix32, matrix33} <= {matrix32, matrix33, row3_data};
		end
	else
		begin
			{matrix11, matrix12, matrix13} <= 24'd0;
			{matrix21, matrix22, matrix23} <= 24'd0;
			{matrix31, matrix32, matrix33} <= 24'd0;
		end		





		
	

endmodule
