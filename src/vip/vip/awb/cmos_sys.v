

module cmos_sys #(
	parameter delay	= 5    ,
	parameter IW 	= 1920 ,
	parameter IH 	= 1080
)
(
	input   wire                    rst_n               ,
	
	input	wire			       	pre_clk				,
	input	wire			        pre_vs				,
	input	wire			        pre_de 		    	,
	input	wire    [23:0]		    pre_data			,
	
	input   wire                    post_clk            ,
	output  wire                    post_vs        		,
    output  reg                    	post_de        		,
    output  reg    	[23:0]          post_data        	
);

wire   				full 			;
wire   				empty			;
reg   				rd_en			;
wire    [23:0] 		dout			;
wire    [11:0]		rd_data_count	;
wire    [11:0]		wr_data_count	;
        
reg     [1:0]      	state			;
reg     [15:0]      cnt		    	; 	

reg					pre_vs_r		;
wire                pre_pose		;
wire				ext_pre_pose	;

reg     [4:0] 		post_vs_r		;
wire                post_pose		;

localparam  idle	=	2'b01,
			sys 	=	2'b10;
						
always@(posedge pre_clk)
	if(!rst_n)
		pre_vs_r <= 1'b0;
	else
		pre_vs_r <= pre_vs;

always@(posedge post_clk)
	if(!rst_n)
		post_vs_r <= 5'd0;
	else 
		post_vs_r <= {post_vs_r[3:0],pre_vs};

assign  post_vs =  post_vs_r[4];

assign	pre_pose  =  ~pre_vs_r&&pre_vs;
assign	post_pose =  ~post_vs_r[4]&&post_vs_r[3];

data_sync_ext u1_data_sync_ext(
	.clka			(pre_clk		),
	.rst_n			(rst_n			),	
	.pulse_a		(pre_pose		),
	.ext_pulse_a	(ext_pre_pose	)
);

always@(posedge post_clk)
	if(!rst_n)
		begin
			rd_en    		  <= 'd0;
			state             <= 2'b01;
			cnt               <= 'd0;
		end
	else if(pre_pose==1'b1)
		begin
			rd_en    		  <= 'd0;
			state             <= 2'b01;
			cnt               <= 'd0;
		end
	else begin
		case (state)
		    idle: begin
					if(rd_data_count>=delay&&rd_en==1'b0)
						begin
							state  <= sys;
							rd_en  <= 1'b1;
						end
					else
						begin
							state  <= idle;
							rd_en  <= 1'b0;
						end
				  end
			sys:  begin
					if(cnt == IW-1)
						begin
							cnt    <= 'd0;
							state  <= idle;
							rd_en  <= 1'b0;
						end
					else if(rd_en == 1'b1)
						begin
							cnt    <= cnt + 1'b1;
							state  <= sys	 ;
							rd_en  <= rd_en  ;
						end
					else
						begin
							cnt    <= cnt 	;
							state  <= state	;
							rd_en  <= rd_en	;
						end
				  end
		
			default : state  <= idle;
		endcase
	end	

fifo_hdmi_sys u1_fifo_hdmi_sys (
	.rst         		(ext_pre_pose	),
	.wr_clk				(pre_clk		),            
	.rd_clk				(post_clk		),           
	.din				(pre_data		),	           
	.wr_en				(pre_de    		),           
	.rd_en				(rd_en 			),            
	.dout				(dout			),              
	.full				(full			),                   
	.empty				(empty			),                 
	.rd_data_count		(rd_data_count	), 
	.wr_data_count		(wr_data_count	)
);
	
always@(posedge post_clk)
	if(!rst_n)
		post_de <= 1'b0;
	else
		post_de <= rd_en;

always@(posedge post_clk)
	if(!rst_n)
		post_data <= 'd0;
	else
		post_data <= dout;

		
endmodule
