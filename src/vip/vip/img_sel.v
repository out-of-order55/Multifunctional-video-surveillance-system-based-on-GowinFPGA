module img_sel(
    input               clk             ,
    input               rst             ,
    input               key_img_sel     ,
    input               key_sobel_sel   ,
    input               key_bright_sel  ,
    input               key_duibi_sel   ,
    input               key_pinjei_sel  ,

    input               sobel_vs        ,
    input               sobel_de        ,
    input               sobel_data_en   ,
    input[7:0]          sobel_data      ,

    input               cam_vs          ,
    input               cam_data_en     ,
    input[15:0]         cam_data        ,
    input               cam_de          ,

    output              img_vs          ,
    output              img_de          ,
    output              img_data_en     ,
    output[15:0]        img_data_o      

);

wire    key_bri,key_duibi;
key_filter		
#
(
	.CNT_MAX(20'd999_999)
)key_filter_d
(
	.sys_clk	(clk                ),
	.sys_rst_n	(rst                ),
	.key_in		(key_bright_sel      ),
	.key_flag	(key_bri          )
);
key_filter		
#
(
	.CNT_MAX(20'd999_999)
)key_filter_a
(
	.sys_clk	(clk                ),
	.sys_rst_n	(rst                ),
	.key_in		(key_duibi_sel      ),
	.key_flag	(key_duibi          )
);
reg     cnt_bri=0;
always @(posedge clk) begin
    if(key_bri)
        cnt_bri<=1'b0;
    else if(key_duibi)
        cnt_bri<=1'b1;
    else
        cnt_bri<=cnt_bri;
end

//bri_sel
wire        bri_data_en,bri_vs,bri_de;
wire[15:0]  bri_data;

bright  bright_u0(
    .clk         (clk),
    .rst         (rst),
    .rgb_data_i  (cam_data),
    .data_en_i   (cam_data_en),
    .data_en_o   (bri_data_en),
    .key_in      (key_bright_sel),
    .vs_in       (cam_vs),
    .de_in       (cam_de),
    .rgb_data_o  (bri_data),
    .vs_o        (bri_vs),
    .de_o        (bri_de)
);

wire    duibi_data_en,duibi_vs,duibi_de;

wire[15:0]  duibi_data;


//duibi_sel
duibi duibi_u0(
    .clk     (clk),
    .rst     (rst),
    .cam_vs  (cam_vs),
    .cam_de  (cam_de),
    .cam_data(cam_data),
    .data_en_i(cam_data_en),
    .key_in  (key_duibi_sel),
    .pro_vs  (duibi_vs),
    .pro_de  (duibi_de),
    .data_en_o(duibi_data_en),
    .pro_data(duibi_data)
);


//sobel_sel
wire    key_sobel;
key_filter		
#
(
	.CNT_MAX(20'd999_999)
)key_filter_sobel
(
	.sys_clk	(clk                ),
	.sys_rst_n	(rst                ),
	.key_in		(key_sobel_sel      ),
	.key_flag	(key_sobel          )
);
reg     [2:0]cnt_sobel=3'b011;
always @(posedge clk) begin
    if(key_sobel)
        cnt_sobel<=cnt_sobel+1'b1;
    else 
        cnt_sobel<=cnt_sobel;
end
parameter BASE =60 ;
wire     [7:0]thresh;

assign    thresh=({8{(cnt_sobel==4'b0000)}})&(BASE+30)
            |    ({8{(cnt_sobel==4'b0001)}})&(BASE+20)
            |    ({8{(cnt_sobel==4'b0010)}})&(BASE+10)
            |    ({8{(cnt_sobel==4'b0011)}})&(BASE   )
            |    ({8{(cnt_sobel==4'b0100)}})&(BASE-10)
            |    ({8{(cnt_sobel==4'b0101)}})&(BASE-20)
            |    ({8{(cnt_sobel==4'b0110)}})&(BASE-25)
            |    ({8{(cnt_sobel==4'b0111)}})&(BASE-30);

//img_sel
//sobel_sel
wire    key_img;
key_filter		
#
(
	.CNT_MAX(20'd999_999)
)key_filter_img
(
	.sys_clk	(clk                ),
	.sys_rst_n	(rst                ),
	.key_in		(key_img_sel      ),
	.key_flag	(key_img          )
);
reg     cnt_img=0;
always @(posedge clk) begin
    if(key_img)
        cnt_img<=cnt_img+1'b1;
    else 
        cnt_img<=cnt_img;
end
//pinjie

wire        pinjie_vs,pinjie_de,pinjie_en;
wire[15:0]  pinjie_data;  
pinjie pinjie_u0(
    .clk        (clk            ),
    .rst        (rst            ),
    .cam_vs     (vs_sel         ),
    .cam_de     (de_sel         ),
    .cam_data   (data_sel       ),
    .data_en_i  (data_en_sel    ),
    .data_en_o  (pinjie_en      ),
    .pro_vs     (pinjie_vs      ),
    .pro_de     (pinjie_de      ),
    .pro_data   (pinjie_data    )
);
wire    key_sel;
key_filter		
#
(
	.CNT_MAX(20'd999_999)
)key_filter_pinjie
(
	.sys_clk	(clk                ),
	.sys_rst_n	(rst                ),
	.key_in		(key_pinjei_sel     ),
	.key_flag	(key_sel            )
);
reg     cnt_pinjie=1;
always @(posedge clk) begin
    if(key_sel)
        cnt_pinjie<=cnt_pinjie+1'b1;
    else 
        cnt_pinjie<=cnt_pinjie;
end

wire            vs_sel,de_sel,data_en_sel;
wire[15:0]      data_sel;     
assign      vs_sel      = cnt_img?sobel_vs:(cnt_bri?duibi_vs:bri_vs);
assign      de_sel      = cnt_img?sobel_de:(cnt_bri?duibi_de:bri_de);
assign      data_en_sel = cnt_img?sobel_data_en:(cnt_bri?duibi_data_en:bri_data_en);
assign      data_sel    = cnt_img?((sobel_data>thresh)?16'hffff:16'h0000):(cnt_bri?duibi_data:bri_data);

assign      img_vs      = cnt_pinjie?pinjie_vs:vs_sel;
assign      img_de      = cnt_pinjie?pinjie_de:de_sel;
assign      img_data_en = cnt_pinjie?pinjie_en:data_en_sel;
assign      img_data_o  = cnt_pinjie?pinjie_data:data_sel;


endmodule