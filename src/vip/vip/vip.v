module vip(
    input                   clk     ,
    input                   rst     ,
    input                   key_img_sel   ,
    input                   key_sobel_sel ,
    input                   key_bright_sel,
    input                   key_duibi_sel ,
    input                   key_pinjei_sel,
    input                   cam_vs  ,
    input                   cam_de  ,
    input[15:0]             cam_data,
    input                   data_en_i,
    output                  data_en_o,
    output                  pro_vs  ,
    output                  pro_de  ,
    output [15:0]           pro_data
);
wire  [7:0]r={cam_data[15:11],3'b000};
wire  [7:0]g={cam_data[10:5],2'b00};
wire  [7:0]b={cam_data[4:0],3'b000};
wire    post_vs,post_de;



wire[7:0]    Y,CB,CR;
wire    data_en;
VIP_RGB888_YCbCr444  VIP_RGB888_YCbCr444_u0
(
    //global clock
    .clk(clk),               
    .rst_n(rst),             
    .per_img_vsync(cam_vs),  
    .per_img_href(cam_de),   
    .per_img_red(r),       
    .per_img_green(g),      
    .per_img_blue(b),       
    .data_en_i   (data_en_i)
    .data_en_o   (data_en),
    .post_img_vsync(post_vs),
    .post_img_href(post_de),
    .post_img_Y(Y),         
    .post_img_Cb(CB),        
    .post_img_Cr(CR)         
);

    wire        vs_o,de_o;
    wire[7:0]   Y_o;
    wire       data_en_sel;


sobel #(
	.COL(1280),
	.ROW(960)
) 
sobel_u0(
	.clk		(clk)	,
	.rst_n		(rst),
	.y_vs		(post_vs),
    .y_data_en  (data_en),
	.y_de		(post_de),
	.y_data		(Y),
    .sobel_data_en(data_en_sel),
	.sobel_vs	(vs_o),
	.sobel_de	(de_o),
	.sobel_data (Y_o) 
);
// assign  data_en_o=cnt?data_en_sel:data_en_i;
// assign  pro_vs  =cnt?vs_o:cam_vs;
// assign  pro_data=cnt?((Y_o>55)?16'hffff:16'h0000):cam_data;
img_sel img_sel_u0(
    .clk             (clk),
    .rst             (rst),
    .key_img_sel     (key_img_sel),
    .key_sobel_sel   (key_sobel_sel),
    .key_bright_sel  (key_bright_sel),
    .key_duibi_sel   (key_duibi_sel),
    .key_pinjei_sel  (key_pinjei_sel),
    .sobel_vs        (vs_o),
    .sobel_de        (de_o),
    .sobel_data_en   (data_en_sel),
    .sobel_data      (Y_o),
    .cam_vs          (cam_vs),
    .cam_data_en     (data_en_i),
    .cam_data        (cam_data),
    .cam_de          (cam_de),

    .img_vs          (pro_vs),
    .img_de          (pro_de),
    .img_data_en     (data_en_o),
    .img_data_o      (pro_data)

);

endmodule