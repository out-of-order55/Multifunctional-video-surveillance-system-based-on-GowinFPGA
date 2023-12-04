`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/29 23:06:51
// Design Name: 
// Module Name: move_cnter
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


module move_center #(
	parameter COL=640,
	parameter ROW=480,
	parameter DW =24

)
(
	input 						clk    		,
	input 						rst_n  		,	
	input 						i_de 		,
	input  		[DW-1:0]		i_data		,
	output						o_data_en	,
	output reg					o_de   		,
	output reg	[DW-1:0]		o_data	
);

reg  [15:0] 	col_cnt        	;
reg  [15:0] 	row_cnt        	;
	
reg  [15:0] 	hcnt        	;
reg  [15:0] 	vcnt        	;

reg         	cnt_de      	;
reg  [7:0]  	cnt         	;
reg         	o_de_r   		;
	
reg 			o_de_r1     	;
reg				o_de_r3			;
reg  [DW-1:0]	o_data_r   		;

reg  [15:0] 	data_cnt		;

wire          	o_de_r2      	;  
wire [DW-1:0]  	o_data_r2    	;
reg [DW-1:0]  	o_data_r3    	;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		col_cnt <= 'd0;
	else if(col_cnt==COL-1)
		col_cnt <= 'd0;
	else if(i_de==1'b1)
		col_cnt <= col_cnt + 1'b1;
	else
		col_cnt <= col_cnt;
		
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		row_cnt <= 'd0;
	else if(col_cnt==COL-1&&row_cnt==ROW-1)
		row_cnt <= 'd0;
	else if(col_cnt==COL-1)
		row_cnt <= row_cnt + 1'b1;
	else
		row_cnt <= row_cnt;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		o_de_r1  <= 1'b0;
	else if(row_cnt>=1&&row_cnt<=ROW-1&&i_de)
		o_de_r1  <= 1'b1;
	else
		o_de_r1  <= 1'b0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		o_data_r  <= 'd0;
	else if(row_cnt>=1&&row_cnt<=ROW-1&&i_de)
		o_data_r  <= i_data;
	else
		o_data_r  <= 'd0;
			
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cnt_de <= 1'b0;
	else if(cnt=='d100)
		cnt_de <= 1'b0;
	else if(col_cnt==COL-1&&row_cnt==ROW-1)
		cnt_de <= 1'b1;
	else
		cnt_de <= cnt_de;			
				
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cnt <= 'd0;
	else if(cnt=='d100)
		cnt <= 'd0;
	else if(cnt_de==1'b1)
		cnt <= cnt + 1'b1;
	else
		cnt <= cnt;		
		
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		o_de_r <= 1'b0;		
	else if(data_cnt==COL-1)
		o_de_r <= 1'b0;
	else if(cnt=='d100)
		o_de_r <= 1'b1;
	else
		o_de_r <= o_de_r;	

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		data_cnt <='d0;		
	else if(data_cnt==COL-1)
		data_cnt <= 'd0;
	else if(o_de_r==1'b1)
		data_cnt <= data_cnt + 1'b1;
	else
		data_cnt <= data_cnt;	

assign o_de_r2     =   	o_de_r||o_de_r1;	
assign o_data_r2   =	o_de_r1?o_data_r:'d0; 

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		hcnt <= 'd0;
	else if(hcnt==COL-1)
		hcnt <= 'd0;
	else if(o_de_r2==1'b1)
		hcnt <= hcnt + 1'b1;
	else
		hcnt <= hcnt;
		
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		vcnt <= 'd0;
	else if(hcnt==COL-1&&vcnt==ROW-1)
		vcnt <= 'd0;
	else if(hcnt==COL-1)
		vcnt <= vcnt + 1'b1;
	else
		vcnt <= vcnt;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		o_de_r3<= 1'b0;
	else
		o_de_r3<= o_de_r2; 

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		o_data_r3 <= 'd0;
	else if(hcnt>0&&hcnt<COL-1&&vcnt>0&&vcnt<ROW-1)
		o_data_r3<= o_data_r2;
	else
		o_data_r3<= 'd0;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		o_data<=1'b0;
	else
		o_data<=o_data_r3;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		o_de<=1'b0;
	else
		o_de<=o_de_r3;

reg    byte_flag,byte_flag_d0;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        byte_flag<=1'b0;
    else if(o_de_r2) begin
        byte_flag <= ~byte_flag;    
    end
    else begin
        byte_flag <= 1'b0;
    end    
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        byte_flag_d0 <= 0;	        
    end
    else begin
        byte_flag_d0 <= byte_flag;	
    end
end 			
assign	o_data_en=byte_flag_d0;		
endmodule
