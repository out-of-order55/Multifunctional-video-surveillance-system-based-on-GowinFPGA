`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/11 20:21:56
// Design Name: 
// Module Name: mid
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
module	erosion (
	input				clk				,
	input				rst_n			,
	input           	matrix_de		,
	input		[7:0]	matrix11		, 
	input		[7:0]	matrix12		, 
	input		[7:0]	matrix13		,
	input		[7:0]	matrix21		,
	input		[7:0]	matrix22		,
	input		[7:0]	matrix23		,
	input		[7:0]	matrix31		,
	input		[7:0]	matrix32		, 
	input		[7:0]	matrix33		,
	output          	erosion_de		,
	output	reg	[7:0]	erosion_data				
);

wire	[7:0]	max_data1	; 
wire	[7:0]	mid_data1	; 
wire	[7:0]	min_data1	;
	
wire	[7:0]	max_data2	; 
wire	[7:0]	mid_data2	; 
wire	[7:0]	min_data2	;
	
wire	[7:0]	max_data3	; 
wire	[7:0]	mid_data3	; 
wire	[7:0]	min_data3	;

sort_3	u1_sort_3 (
	.clk		(clk		),
	.rst_n		(rst_n		),	
	.data1		(matrix11	), 
	.data2		(matrix12	), 
	.data3		(matrix13	),
	.min_data   (min_data1	),
	.mid_data	(mid_data1	),
	.max_data	(max_data1	)	
);

sort_3	u2_sort_3 (
	.clk		(clk		),
	.rst_n		(rst_n		),	
	.data1		(matrix21	), 
	.data2		(matrix22	), 
	.data3		(matrix23	),	
	.min_data   (min_data2	),
	.mid_data	(mid_data2	),
	.max_data	(max_data2	)	
);

sort_3	u3_sort_3 (
	.clk		(clk		),
	.rst_n		(rst_n		),
	.data1		(matrix31	), 
	.data2		(matrix32	), 
	.data3		(matrix33	),	
	.min_data   (min_data3	),
	.mid_data	(mid_data3	),
	.max_data	(max_data3	)	
);

wire [7:0] target_data      ;  
 
sort_3	u4_sort_3 (
	.clk		(clk			),
	.rst_n		(rst_n			),		
	.data1		(min_data1		), 
	.data2		(min_data2		), 
	.data3		(min_data3		),
	.min_data   (target_data	),
	.mid_data	(				),
	.max_data	(				)
);

reg [3:0] matrix_de_r;

always@(posedge clk)
	if(!rst_n)
		matrix_de_r	 <=  4'd0;
	else
		matrix_de_r	  <=  {matrix_de_r[2:0],matrix_de};
		
always@(posedge clk)
	if(!rst_n)
		erosion_data	 <=  8'd0;
	else if(matrix_de_r[1]==1'b1)
		erosion_data	 <=  target_data;	
	else
		erosion_data	 <=  8'd0;

	
assign erosion_de = matrix_de_r[2];



endmodule
