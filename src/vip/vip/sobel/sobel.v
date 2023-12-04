`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/13 23:18:52
// Design Name: 
// Module Name: gassin_filter
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
//Sobel Parameter
//         x                   y				        Pixel
// [   -1  0   +1  ]   [   +1  +2   +1 ]     [   P11  P12   P13 ]
// [   -2  0   +2  ]   [   0   0    0  ]     [   P21  P22   P23 ]
// [   -1  0   +1  ]   [   -1  -2   -1 ]     [   P31  P32   P33 ]
module sobel #(
	parameter COL=640,
	parameter ROW=480
) 
(
	input 				clk			,
	input 				rst_n		,
	input               y_vs		,
	input               y_de		,
	input				y_data_en	,
	input  [7:0] 		y_data		,
	output          	sobel_vs	,
	output				sobel_data_en,
	output          	sobel_de	,
	output [7:0]    	sobel_data   
);

reg				y_vs_r		 	 ;
wire			y_pose		 	 ; 
wire			ext_y_pose	 	 ;

wire   [7:0]	matrix11     	 ;
wire   [7:0]    matrix12     	 ;
wire   [7:0]    matrix13     	 ;
	 
wire   [7:0]	matrix21     	 ;
wire   [7:0]    matrix22     	 ;
wire   [7:0]    matrix23     	 ;
	 
wire   [7:0]	matrix31     	 ;
wire   [7:0]    matrix32     	 ;
wire   [7:0]    matrix33     	 ;
	 
wire            matrix_de	 	 ;
	 
reg    [23:0]    matrix_de_r  	 ;
	 
reg    [15:0]   x_one_line     	 ;
reg    [15:0]   x_second_line  	 ;
reg    [15:0]   x_third_line   	 ;

reg    [15:0]   y_one_line     	 ;
reg    [15:0]   y_second_line  	 ;
reg    [15:0]   y_third_line   	 ;
	 
reg    [15:0]   x_add_line     	 ;
reg    [15:0]   y_add_line     	 ;

reg    [15:0]   abs_x_add_line   ;
reg    [15:0]   abs_y_add_line   ;

reg    [31:0]   x_add_line_2     ;
reg    [31:0]   y_add_line_2     ;

reg	   [31:0]	xy_add_line_2    ;

reg	            pre_sobel_de     ;
reg	   [23:0]   pre_sobel_data   ;

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
wire	matrix_en;

matrix	#(
	.COL(COL),
    .ROW(ROW)
)
u1_matrix
(
	.clk		(clk		),
	.rst_n		(~ext_y_pose     ),
	.data_de	(y_de		),
	.data_en	(y_data_en  ),
	.data		(y_data		),
	.matrix_en  (matrix_en  ),
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
reg		[23:0]matrix_en_r;
reg		[25:0]matrix_vs_r;
always@(posedge clk)
	if(!rst_n)
		matrix_de_r	 <=  5'd0;
	else
		matrix_de_r	 <=  {matrix_de_r[22:0],matrix_de};	

always@(posedge clk)
	if(!rst_n)
		matrix_vs_r	 <=  5'd0;
	else
		matrix_vs_r	 <=  {matrix_vs_r[24:0],y_vs};	

always@(posedge clk)
	if(!rst_n)
		matrix_en_r<='d0;
	else
		matrix_en_r<={matrix_en_r[22:0],matrix_en};

always@(posedge clk)
	if(!rst_n)
		x_one_line <= 'd0;
	else if(matrix_de==1'b1)
		x_one_line <= -matrix11+matrix12*0+matrix13;
	else	
		x_one_line <= 'd0;

always@(posedge clk)
	if(!rst_n)
		x_second_line <= 'd0;
	else if(matrix_de==1'b1)
		x_second_line <= -2*matrix21+matrix22*0+matrix23*2;
	else	
		x_second_line <='d0;				

always@(posedge clk)
	if(!rst_n)
		x_third_line <= 'd0;
	else if(matrix_de==1'b1)
		x_third_line <= -matrix31+matrix32*0+matrix33;
	else	
		x_third_line <='d0;
		
always@(posedge clk)
	if(!rst_n)
		x_add_line <= 'd0;
	else if(matrix_de_r[0]==1'b1)
		x_add_line <= x_one_line+x_second_line+x_third_line;
	else	
		x_add_line <= 'd0;

always@(posedge clk)
	if(!rst_n)
		y_one_line <= 'd0;
	else if(matrix_de==1'b1)
		y_one_line <= matrix11+matrix12*2+matrix13;
	else	
		y_one_line <= 'd0;

always@(posedge clk)
	if(!rst_n)
		y_second_line <= 'd0;
	else if(matrix_de==1'b1)
		y_second_line <= matrix21*0+matrix22*0+matrix23*0;
	else	
		y_second_line <='d0;				

always@(posedge clk)
	if(!rst_n)
		y_third_line <= 'd0;
	else if(matrix_de==1'b1)
		y_third_line <= -matrix31-2*matrix32-matrix33;
	else	
		y_third_line <='d0;
		
always@(posedge clk)
	if(!rst_n)
		y_add_line <= 'd0;
	else if(matrix_de_r[0]==1'b1)
		y_add_line <= y_one_line+y_second_line+y_third_line;
	else	
		y_add_line <= 'd0;

always@(posedge clk)
	if(!rst_n)
		abs_x_add_line <= 'd0;
	else if(x_add_line[15]==1'b1)
		abs_x_add_line <= 65536 - x_add_line;
	else
		abs_x_add_line <= x_add_line;

always@(posedge clk)
	if(!rst_n)
		abs_y_add_line <= 'd0;
	else if(y_add_line[15]==1'b1)
		abs_y_add_line <= 65536 - y_add_line;
	else
		abs_y_add_line <= y_add_line;

always@(posedge clk)
	if(!rst_n)
		x_add_line_2 <= 'd0;
	else
		x_add_line_2 <= abs_x_add_line*abs_x_add_line;
		
always@(posedge clk)
	if(!rst_n)
		y_add_line_2 <= 'd0;
	else
		y_add_line_2 <= abs_y_add_line*abs_y_add_line;		

always@(posedge clk)
	if(!rst_n)
		xy_add_line_2 <= 'd0;
	else
		xy_add_line_2 <= x_add_line_2 + y_add_line_2;

wire			square_de  		;
wire    [23:0]	square_data	    ;


sqrt	sqrt_u0
(
    .clk     		(clk			),
    .rst     		(~rst_n			),
    .data_i         (xy_add_line_2	),
	.i_vaild   		(matrix_de_r[4]	),
	.data_o        	(square_data	),   
	.o_vaild		(square_de		)
);

always@(posedge clk)
	if(!rst_n)
		pre_sobel_de <= 1'b0;
	else
		pre_sobel_de <= square_de;
		
always@(posedge clk)
	if(!rst_n)
		pre_sobel_data <= 1'b0;
	else if(square_data>=255)
		pre_sobel_data <= 255;		
  	else
		pre_sobel_data <= square_data; 
wire	[7:0]	data;	 
move_center	#(
	.COL(COL),
	.ROW(ROW),
	.DW (8  )
)
u1_move_center(
	.clk    		(clk   				),
	.rst_n  		(~ext_y_pose		),
	.i_de 			(pre_sobel_de  		),
	.i_data			(pre_sobel_data		),
	.o_de   		(sobel_de 			),
	.o_data_en		(),
	.o_data	    	(sobel_data    		)
);			
assign	sobel_data_en=matrix_en_r[23];
assign sobel_vs =matrix_vs_r[24];
       
endmodule
