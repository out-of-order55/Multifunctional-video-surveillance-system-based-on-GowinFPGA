
module pinjie(
    input                   clk     ,
    input                   rst     ,
    input                   cam_vs  ,
    input                   cam_de  ,
    input[15:0]             cam_data,
    input                   data_en_i,
	
	input					sobel_vs,
	input					sobel_de,
	input					sobel_data_en,
	input[15:0]			    sobel_data,

    output                  data_en_o,
    output                  pro_vs  ,
    output                  pro_de  ,
    output [15:0]           pro_data
);


wire	cam_vs0,cam_de0,cam_data_en0,cam_vs1,cam_de1,cam_data_en1,cam_pre_de0,cam_pre_de1;
wire[15:0]	cam_data0,cam_data1;

couper #(
	.IW 		(1280	),
	.IH 		(960	),	
	.DW 		(16		),	
	.COUPER_W 	(640	),
	.COUPER_V 	(480	),
	.HL_ZONE 	(0		),	//裁剪区域左边界
	.VU_ZONE 	(0      )   //裁剪区域上边界
)
couper_u0(
	.clk			(clk   			),
	.rst_n			(rst        	),
	.per_vs			(cam_vs    		),		
	.per_de			(cam_de    		),
    .pre_data_en    (data_en_i  	),		
	.per_data		(cam_data   	),				
	.post_vs		(cam_vs0    	),	
	.post_de		(cam_de0    	),
    .post_data_en   (cam_data_en0	),
	.post_pre_de	(cam_pre_de0	),		
	.post_data      (cam_data0      )
);

couper #(
	.IW 		(1280	),
	.IH 		(960	),	
	.DW 		(16		),	
	.COUPER_W 	(640	),
	.COUPER_V 	(480	),
	.HL_ZONE 	(340	),	//裁剪区域左边界
	.VU_ZONE 	(0    	)	   //裁剪区域上边界
)
couper_u1(
	.clk			(clk   		),
	.rst_n			(rst        ),
	.per_vs			(cam_vs    	),		
	.per_de			(cam_de    	),
    .pre_data_en    (data_en_i  ),		
	.per_data		(cam_data   ),				
	.post_vs		(cam_vs1    ),	
	.post_de		(cam_de1    ),
	.post_pre_de	(cam_pre_de1),
    .post_data_en   (cam_data_en1),		
	.post_data      (cam_data1   )
);


cmos_out cmos_out_u0(
    .clk			(clk		),
    .rst_n			(rst		),
    .cam_vs0		(cam_vs0	),
    .cam_de0		(cam_de0	),
    .cam_vs1		(cam_vs1	),
    .cam_de1		(cam_de1	),
    .cam_data0		(cam_data0	),
    .cam_data1		(cam_data1	),
    .cam_data_en0	(cam_data_en0),
    .cam_data_en1	(cam_data_en1),
    .cam_pre_de0	(cam_pre_de0),
    .cam_pre_de1	(cam_pre_de1),
    .cam_de_o		(pro_de),
    .cam_vs_o		(pro_vs),
    .cam_data_en_o	(data_en_o),
    .cam_data_o		(pro_data)   
);

endmodule