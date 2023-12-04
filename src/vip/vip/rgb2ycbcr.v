`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/10 19:43:07
// Design Name: 
// Module Name: rgb2ycbcr
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
// 	Y 	=	(77 *R 	+ 	150*G 	+ 	29 *B)>>8
//	Cb 	=	(-43*R	- 	85 *G	+ 	128*B)>>8 + 128
//	Cr 	=	(128*R 	-	107*G  	-	21 *B)>>8 + 128
//--->
//	Y 	=	(77 *R 	+ 	150*G 	+ 	29 *B)>>8
//	Cb 	=	(-43*R	- 	85 *G	+ 	128*B + 32768)>>8
//	Cr 	=	(128*R 	-	107*G  	-	21 *B + 32768)>>8
//////////////////////////////////////////////////////////////////////////////////
module rgb2ycbcr (
	input					clk					,
	input					rst_n				,
	
	input					i_vs				,		
	input					i_de				,	
	input			[7:0]	i_r					,		
	input			[7:0]	i_g					,		
	input			[7:0]	i_b					,		
	
	output		reg			o_vs				,	
	output		reg			o_de				,	
	output		reg	[7:0]	o_y					,			
	output		reg	[7:0]	o_cb				,		
	output		reg	[7:0]	o_cr			
);

reg	[15:0]	i_r0	;
reg	[15:0]	i_r1 	;
reg	[15:0]	i_r2	;

reg	[15:0]	i_g0	;
reg	[15:0]	i_g1 	;
reg	[15:0]	i_g2	;

reg	[15:0]	i_b0	;
reg	[15:0]	i_b1 	;
reg	[15:0]	i_b2	;

reg	[15:0]	o_y0	;
reg	[15:0]	o_cb0	;
reg	[15:0]	o_cr0	;

reg			i_vs_d0 ;
reg			i_de_d0 ;

reg			i_vs_d1 ;
reg			i_de_d1 ;

always@(posedge clk)
	if(!rst_n)
		begin
			i_r0	<=   'd0; 	
			i_r1 	<=   'd0;
			i_r2	<=   'd0;
		end
	else
		begin
			i_r0	<=   i_r * 77	; 
			i_r1 	<=   i_r * 43	; 
			i_r2	<=   i_r * 128	;
		end

always@(posedge clk)
	if(!rst_n)
		begin
			i_g0	<=   'd0; 	
			i_g1 	<=   'd0;
			i_g2	<=   'd0;
		end
	else
		begin
			i_g0	<=   i_g * 150	; 
			i_g1 	<=   i_g * 85	;  
			i_g2	<=   i_g * 107	;
		end
	
always@(posedge clk)
	if(!rst_n)
		begin
			i_b0	<=   'd0; 	
			i_b1 	<=   'd0;
			i_b2	<=   'd0;
		end
	else
		begin
			i_b0	<=   i_b * 29	;
			i_b1 	<=   i_b * 128	;
			i_b2	<=   i_b * 21	;
		end
		
always@(posedge clk)
	if(!rst_n)
		begin
			o_y0	<=	0; 		
			o_cb0	<=	0; 		
			o_cr0	<=	0; 	
		end
	else
		begin
			o_y0	<=	i_r0 + i_g0	+ i_b0 			;	
			o_cb0	<=	i_r1 - i_g1	- i_b1 + 32768	; 		
			o_cr0	<=	i_r2 + i_g2	+ i_b2 + 32768	; 		
		end

always@(posedge clk)
	if(!rst_n)
		begin
			i_vs_d0	<= 'd0;
			i_de_d0 <= 'd0;
			i_vs_d1 <= 'd0;
			i_de_d1 <= 'd0;
		end
	else
		begin
        	i_vs_d0	<= i_vs		;
        	i_de_d0 <= i_de		;
	    	i_vs_d1 <= i_vs_d0	;
        	i_de_d1 <= i_de_d0 	; 
		end 
    
always@(posedge clk)
	if(!rst_n)
		begin
			o_vs <= 'd0;
			o_de <= 'd0;
		end
	else
		begin
        	o_vs <= i_vs_d1 ;
        	o_de <= i_de_d1 ;
		end 
	
always@(posedge clk)
	if(!rst_n)
		begin
			o_y		<=	'd0	; 		
			o_cb	<=	'd0	; 		
			o_cr	<=	'd0	; 	
		end
	else
		begin
			o_y		<=	o_y0	/  256;
			o_cb	<=	o_cb0	/  256;
			o_cr	<=	o_cr0	/  256; 
		end
	


endmodule
