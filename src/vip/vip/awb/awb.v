`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/09/15 14:09:14
// Design Name: 
// Module Name: awb
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


module awb #(
	parameter COL = 1280,
	parameter ROW = 720
)
(
	input					clk			,
	
	input   				pre_vs		,
	input   				pre_de		,
	input   	 [23:0]		pre_data	,
	
	output  reg     		post_vs		,
	output	reg     		post_de		,
	output  reg	 [23:0]		post_data		
);

reg			pre_vs_r	;

wire		vs_pose		;
wire		ext_vs_pose	;

reg			rst_n		;	

reg [15:0] 	hcnt		;
reg [15:0] 	vcnt		;
	
reg			accu_de		;	
	
reg [31:0] 	accu_r		;
reg [31:0] 	accu_g		;
reg [31:0] 	accu_b		;
	
reg		   	accu_ava_de	;
		
reg [63:0] 	accu_r_ava 	;
reg [63:0] 	accu_g_ava 	;
reg [63:0] 	accu_b_ava 	;
		
wire[15:0] 	recip_r	  	;
wire[15:0] 	recip_g	  	;
wire[15:0] 	recip_b	  	;
		
reg [22:0] 	gain_r	= 0 ;
reg [22:0] 	gain_g	= 0 ;
reg [22:0] 	gain_b	= 0 ;

reg			awb_de		;	
	
reg [31:0] 	awb_r	  	;
reg [31:0] 	awb_g	  	;
reg [31:0] 	awb_b	  	;

localparam [63:0] total_recip = (2**31)/(COL*ROW);//1/(COL*ROW)

always@(posedge clk)
	pre_vs_r <= pre_vs;

assign vs_pose = ~pre_vs_r&&pre_vs;

data_sync_ext u1_data_sync_ext(
	.clka			(clk			),
	.rst_n			(1'b1			),	
	.pulse_a		(vs_pose		),
	.ext_pulse_a	(ext_vs_pose	)
);

always@(posedge clk)
	rst_n <= ~ext_vs_pose;

always@(posedge clk)
	if(!rst_n)
		hcnt <= 'd0;
	else if(hcnt==COL-1)
		hcnt <= 'd0;
	else if(pre_de==1'b1)
		hcnt <= hcnt + 1'b1;
	else
		hcnt <= hcnt;
		
always@(posedge clk)
	if(!rst_n)
		vcnt <= 'd0;
	else if(hcnt==COL-1&&vcnt==ROW-1)
		vcnt <= 'd0;
	else if(hcnt==COL-1)
		vcnt <= vcnt + 1'b1;
	else
		vcnt <= vcnt;

always@(posedge clk)
	if(!rst_n)
		accu_de <= 1'b0;
	else if(hcnt==COL-1&&vcnt==ROW-1)
		accu_de <= 1'b1;
	else	
		accu_de <= 1'b0;
		
always@(posedge clk)
	if(!rst_n)
		begin
			accu_r <= 'd0;
			accu_g <= 'd0;
			accu_b <= 'd0;
		end
	else if(accu_de==1'b1)
		begin
			accu_r <= 'd0;
			accu_g <= 'd0;
			accu_b <= 'd0;
		end		
	else if(pre_de==1'b1)
		begin
			accu_r <= accu_r + pre_data[23:16];
			accu_g <= accu_g + pre_data[15:8];
			accu_b <= accu_b + pre_data[7:0];
		end		
	else
		begin
        	accu_r <= accu_r  ;
        	accu_g <= accu_g  ;
        	accu_b <= accu_b  ;
        end		

always@(posedge clk)
	if(!rst_n)
		accu_ava_de <= 1'b0;
	else if(accu_de==1'b1)
		accu_ava_de <= 1'b1;
	else
		accu_ava_de <= 1'b0;	
		
always@(posedge clk)
	if(!rst_n)
		begin
	    	accu_r_ava <= 'd0;
	    	accu_g_ava <= 'd0;
	    	accu_b_ava <= 'd0;
        end
	else if(accu_de==1'b1)
		begin
			accu_r_ava <= accu_r*total_recip;
			accu_g_ava <= accu_g*total_recip;
			accu_b_ava <= accu_b*total_recip;		
		end
	else
		begin
	    	accu_r_ava <= 'd0;
	    	accu_g_ava <= 'd0;
	    	accu_b_ava <= 'd0;
        end

recip u1_recip(
	.ava	(accu_r_ava[38:31]	),
	.recip	(recip_r			)
);

recip u2_recip(
	.ava	(accu_g_ava[38:31]	),
	.recip	(recip_g			)
);

recip u3_recip(
	.ava	(accu_b_ava[38:31]	),
	.recip	(recip_b			)
);

always@(posedge clk)
	if(accu_ava_de==1'b1)
		begin
			gain_r <= 128*recip_r;
			gain_g <= 128*recip_g;
			gain_b <= 128*recip_b;
		end		
	else
		begin
			gain_r <= gain_r; 
			gain_g <= gain_g;
			gain_b <= gain_b;
        end	
		
always@(posedge clk)
	if(!rst_n)
		awb_de <= 1'b0;
	else
		awb_de <= pre_de;
		
always@(posedge clk)
	if(!rst_n)
		begin
			awb_r <= 'd0;
			awb_g <= 'd0;
			awb_b <= 'd0;
		end
	else
		begin
			awb_r <= gain_r*pre_data[23:16];
			awb_g <= gain_g*pre_data[15:8];
			awb_b <= gain_b*pre_data[7:0];
		end	
		
always@(posedge clk)
	post_vs <= pre_vs;	
		
always@(posedge clk)
	if(!rst_n)
		post_de <= 1'b0;
	else
		post_de <= awb_de;	
	
always@(posedge clk)
	if(!rst_n)
		post_data[7:0] <= 'd0;
	else if(awb_b[31:16]>8'd255)//awb_b/65536 , awb_b>>16
		post_data[7:0] <= 255;
	else
		post_data[7:0] <= awb_b[23:16];

always@(posedge clk)
	if(!rst_n)
		post_data[15:8] <= 'd0;
	else if(awb_g[31:16]>8'd255)
		post_data[15:8] <= 255;
	else
		post_data[15:8] <= awb_g[23:16];
		
always@(posedge clk)
	if(!rst_n)
		post_data[23:16] <= 'd0;
	else if(awb_r[31:16]>8'd255)
		post_data[23:16] <= 255;
	else
		post_data[23:16] <= awb_r[23:16];
		
/* ila_0 u1_ila_0 (
	.clk(clk), // input wire clk
	.probe0({
	
	rst_n			,	
	pre_vs		    ,
	pre_de		    ,
	pre_data	    ,
	pre_vs		    ,
	pre_de		    ,
	pre_data		,
	
	hcnt			,		
	vcnt			,
	
	accu_r			,
	recip_r			,
	gain_r			
	}) // input wire [99:0] probe0
);  */  




endmodule
