`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/11 17:21:56
// Design Name: 
// Module Name: mid_filiter
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


module erosion_filiter #(
	parameter COL=640,
	parameter ROW=480
) 
(
	input 				clk			,
	input 				rst_n		,
	
	input               y_vs		,
	input               y_de		,
	input  [7:0] 		y_data		,
	
	output          	erosion_vs	,
	output          	erosion_de	,
	output [7:0]    	erosion_data   
);
reg				y_vs_r		 ;
wire			y_pose		 ;
wire			ext_y_pose	 ;

wire            matrix_de	 	 ; 
	                             
wire   [7:0]	matrix11     	 ;
wire   [7:0]    matrix12     	 ;
wire   [7:0]    matrix13     	 ;
	                             
wire   [7:0]	matrix21     	 ;
wire   [7:0]    matrix22     	 ;
wire   [7:0]    matrix23     	 ;
	                             
wire   [7:0]	matrix31     	 ;
wire   [7:0]    matrix32     	 ;
wire   [7:0]    matrix33     	 ;

wire            pre_erosion_de   ;
wire   [7:0]    pre_erosion_data ;

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
	.clk			(clk			),
	.rst_n			(~ext_y_pose			),
	.data_de		(y_de			),
	.data			(y_data			),
	.matrix_de		(matrix_de		),
	.matrix11		(matrix11		),
	.matrix12   	(matrix12		),
	.matrix13   	(matrix13		),
	.matrix21   	(matrix21		),
	.matrix22   	(matrix22		),
	.matrix23   	(matrix23		),
	.matrix31   	(matrix31		),
	.matrix32   	(matrix32		),
	.matrix33   	(matrix33		)
);

erosion u1_erosion(
	.clk			(clk			),
	.rst_n			(~ext_y_pose			),
	.matrix_de		(matrix_de		),
	.matrix11		(matrix11		), 
	.matrix12		(matrix12		), 
	.matrix13		(matrix13		),
	.matrix21		(matrix21		), 
	.matrix22		(matrix22		), 
	.matrix23		(matrix23		),
	.matrix31		(matrix31		), 
	.matrix32		(matrix32		), 
	.matrix33		(matrix33		),
	.erosion_de		(pre_erosion_de  ),
	.erosion_data   (pre_erosion_data)
);

move_center	#(
	.COL(COL),
	.ROW(ROW),
	.DW (8  )
)
u1_move_center(
	.clk    		(clk   				),
	.rst_n  		(~ext_y_pose 		),
	.i_de 			(pre_erosion_de  	),
	.i_data			(pre_erosion_data	),
	.o_de   		(erosion_de			),
	.o_data	    	(erosion_data   	)
);	
	

assign erosion_vs = y_vs;


endmodule
