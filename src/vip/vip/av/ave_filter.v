`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/13 23:18:52
// Design Name: 
// Module Name: ave_filter
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

module ave_filter #(
	parameter COL=640,
	parameter ROW=480
) 
(
	input 				clk			,
	input 				rst_n		,
	input               y_vs		,
	input               y_de		,
	input  [7:0] 		y_data		,
	output          	ave_vs		,
	output          	ave_de		,
	output [7:0]    	ave_data   
);

reg				y_vs_r		 ;
wire			y_pose		 ;
wire			ext_y_pose	 ;

wire            matrix_de	 ;

wire   [7:0]	matrix11     ;
wire   [7:0]    matrix12     ;
wire   [7:0]    matrix13     ;

wire   [7:0]	matrix21     ;
wire   [7:0]    matrix22     ;
wire   [7:0]    matrix23     ;

wire   [7:0]	matrix31     ;
wire   [7:0]    matrix32     ;
wire   [7:0]    matrix33     ;

reg    [3:0]    matrix_de_r  ;

reg    [15:0]   one_line     ;
reg    [15:0]   second_line  ;
reg    [15:0]   third_line   ;

reg    [15:0]   add_line     ;

reg             pre_ave_de    ;
reg    [31:0]   pre_ave_data0 ;
wire   [7:0]    pre_ave_data  ;

always@(posedge clk)
	if(!rst_n)
		y_vs_r <= 1'd0;
	else 
		y_vs_r <= y_vs;

assign	y_pose	= ~y_vs_r&&y_vs	;

data_sync_ext u1_data_sync_ext(
	.clka			(clk			),
	.rst_n			(rst_n			),	
	.pulse_a		(y_pose			),
	.ext_pulse_a	(ext_y_pose		)
);

matrix	#(
	.COL(COL),
    .ROW(ROW)
)
u1_matrix
(
	.clk		(clk		),
	.rst_n		(~ext_y_pose),
	.data_de	(y_de		),
	.data		(y_data		),
	.matrix_de	(matrix_de	),
	.matrix11	(matrix11	),
	.matrix12   (matrix12	),
	.matrix13   (matrix13	),
	.matrix21   (matrix21	),
	.matrix22   (matrix22	),
	.matrix23   (matrix23	),
	.matrix31   (matrix31	),
	.matrix32   (matrix32	),
	.matrix33   (matrix33	)
);

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		matrix_de_r	 <=  4'd0;
	else
		matrix_de_r	 <=  {matrix_de_r[2:0],matrix_de};
		
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		one_line <= 'd0;
	else if(matrix_de==1'b1)
		one_line <= matrix11+matrix12+matrix13;
	else	
		one_line <= 'd0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		second_line <= 'd0;
	else if(matrix_de==1'b1)
		second_line <= matrix21+matrix22+matrix23;
	else	
		second_line <='d0;				

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		third_line <= 'd0;
	else if(matrix_de==1'b1)
		third_line <= matrix31+matrix32+matrix33;
	else	
		third_line <='d0;
		
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		add_line <= 'd0;
	else if(matrix_de_r[0]==1'b1)
		add_line <= one_line+second_line+third_line;
	else	
		add_line <= 'd0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		pre_ave_de <= 1'b0;
	else  if(matrix_de_r[1]==1'b1)
		pre_ave_de <= 1'b1;
	else
		pre_ave_de <= 1'b0;
		
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		pre_ave_data0 <= 'd0;
	else  if(matrix_de_r[1]==1'b1)
		pre_ave_data0 <= add_line*7282;
	else
		pre_ave_data0 <= 'd0;	
	
assign pre_ave_data = pre_ave_data0[23:16];
	
move_center	#(
	.COL(COL),
	.ROW(ROW),
	.DW (8  )
)
u1_move_center(
	.clk    		(clk   			),
	.rst_n  		(~ext_y_pose	),
	.i_de 			(pre_ave_de  	),
	.i_data			(pre_ave_data	),
	.o_de   		(ave_de			),
	.o_data	    	(ave_data   	)
);		

assign ave_vs = y_vs;

endmodule
