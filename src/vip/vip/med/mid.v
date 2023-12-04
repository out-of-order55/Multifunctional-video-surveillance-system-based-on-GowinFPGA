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
module	mid (
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
	output          	mid_de			,
	output	reg	[7:0]	mid_data				
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

wire	[7:0]	max_min_data; 
wire	[7:0]	mid_mid_data; 
wire	[7:0]	min_max_data;

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

sort_3	u4_sort_3 (
	.clk		(clk			),
	.rst_n		(rst_n			),		
	.data1		(max_data1		), 
	.data2		(max_data2		), 
	.data3		(max_data3		),
	.min_data   (max_min_data	),
	.mid_data	(				),
	.max_data	(				)
);

sort_3	u5_sort_3 (

	.clk		(clk			),
	.rst_n		(rst_n			),
	
	.data1		(mid_data1		), 
	.data2		(mid_data2		), 
	.data3		(mid_data3		),
	.min_data   (				),
	.mid_data	(mid_mid_data	),
	.max_data	(				)
);

sort_3	u6_sort_3 (
	.clk		(clk			),
	.rst_n		(rst_n			),	
	.data1		(min_data1		), 
	.data2		(min_data2		), 
	.data3		(min_data3		),	
	
	.min_data   (				),
	.mid_data	(				),
	.max_data	(min_max_data	)	
);

wire [7:0] target_data      ;   

sort_3	u7_sort_3 (

	.clk		(clk			),
	.rst_n		(rst_n			),
	
	.data1		(max_min_data	), 
	.data2		(mid_mid_data	), 
	.data3		(min_max_data	),
	.min_data   (				),
	.mid_data	(target_data	),
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
		mid_data	 <=  8'd0;
	else if(matrix_de_r[2]==1'b1)
		mid_data	 <=  target_data;	
	else
		mid_data	 <=  8'd0;

	
assign mid_de = matrix_de_r[3];



endmodule
