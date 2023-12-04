//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/01 19:39:38
// Design Name: 
// Module Name: sort_3
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
module	sort_3(
	input				clk			,
	input				rst_n		,
	
	input		[7:0]	data1		, 
	input		[7:0]	data2		, 
	input		[7:0]	data3		,
	output	reg	[7:0]	min_data	,	
	output	reg	[7:0]	mid_data	, 
	output	reg	[7:0]	max_data	
);
		
always@(posedge clk)
	if(!rst_n)
		min_data <= 0;
	else if(data1 <= data2 && data1 <= data3)
		min_data <= data1;
	else if(data2 <= data1 && data2 <= data3)
		min_data <= data2;
	else
		min_data <= data3;
		
always@(posedge clk)
	if(!rst_n)
		mid_data <= 0;
	else if((data1 >= data2 && data1 <= data3) || (data1 >= data3 && data1 <= data2))
		mid_data <= data1;
	else if((data2 >= data1 && data2 <= data3) || (data2 >= data3 && data2 <= data1))
		mid_data <= data2;
	else
		mid_data <= data3;	
		
always@(posedge clk)
	if(!rst_n)
		max_data <= 0;
	else if(data1 >= data2 && data1 >= data3)
		max_data <= data1;
	else if(data2 >= data1 && data2 >= data3)
		max_data <= data2;
	else
		max_data <= data3;
		

		



endmodule
