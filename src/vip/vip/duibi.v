module duibi(
    input                   clk     ,
    input                   rst     ,
    input                   key_in  ,
    input                   cam_vs  ,
    input                   cam_de  ,
    input[15:0]             cam_data,
    input                   data_en_i,
    output                  data_en_o,
    output                  pro_vs  ,
    output                  pro_de  ,
    output  [15:0]          pro_data
);

wire  [7:0]r= {cam_data[15:11],3'b000};
wire  [7:0]g= {cam_data[10:5],2'b00};
wire  [7:0]b= {cam_data[4:0],3'b000};
wire    post_vs,post_de;
wire    post_data_en;
wire[7:0]    Y,CB,CR;
VIP_RGB888_YCbCr444  VIP_RGB888_YCbCr444_duibi
(
    //global clock
    .clk(clk),                //cmos video pixel clock
    .rst_n(rst),              //global reset
    .per_img_vsync(cam_vs),      //Prepared Image data vsync valid signal
    .per_img_href(cam_de),       //Prepared Image data href vaild signal
    .data_en_i(data_en_i),
    .per_img_red(r),        //Prepared Image red data to be processed
    .per_img_green(g),      //Prepared Image green data to be processed
    .per_img_blue(b),       //Prepared Image blue data to be processed
    .post_img_vsync(post_vs),     //Processed Image data vsync valid signal
    .post_img_href(post_de),      //Processed Image data href vaild signal
    .data_en_o(post_data_en),
    .post_img_Y(Y),         //Processed Image brightness output
    .post_img_Cb(CB),        //Processed Image blue shading output
    .post_img_Cr(CR)         //Processed Image red shading output
);

wire    key_flag;
key_filter		
#
(
	.CNT_MAX(20'd999_999)
)key_filter_duibi
(
	.sys_clk	(clk        ),
	.sys_rst_n	(rst        ),
	.key_in		(key_in     ),
	.key_flag	(key_flag   )
);
reg     [2:0]cnt=0;
always @(posedge clk) begin
    if(key_flag)
        cnt<=cnt+1'b1;
    else if(cnt==3'b110)
        cnt<=1'b0;
    else 
        cnt<=cnt;
end

wire        [7:0]  Y_o0,Y_o1,Y_o2,Y_o3,Y_o4,Y_o5;
reg         [7:0]   Y_o,CB_o,CR_o;
Curve_Contrast_Array_2 Curve_Contrast_Array_2_u0(
    .Pre_Data    (Y),
    .Post_Data   (Y_o0)
);
Curve_Contrast_Array_3 Curve_Contrast_Array_3_u0(
    .Pre_Data    (Y),
    .Post_Data   (Y_o1)
);
Curve_Contrast_Array_4 Curve_Contrast_Array_4_u0(
    .Pre_Data    (Y),
    .Post_Data   (Y_o2)
);
Curve_Contrast_Array_5 Curve_Contrast_Array_5_u0(
    .Pre_Data    (Y),
    .Post_Data   (Y_o3)
);
Curve_Contrast_Array_6 Curve_Contrast_Array_6_u0(
    .Pre_Data    (Y),
    .Post_Data   (Y_o4)
);
Curve_Contrast_Array_7 Curve_Contrast_Array_7_u0(
    .Pre_Data    (Y),
    .Post_Data   (Y_o5)
);
always@(posedge clk)begin
    case(cnt)
        3'b000:Y_o<=Y;
        3'b001:Y_o<=Y_o0;
        3'b010:Y_o<=Y_o1;
        3'b011:Y_o<=Y_o2;
        3'b100:Y_o<=Y_o3;
        3'b101:Y_o<=Y_o5;
        3'b110:Y_o<=Y_o5;
        default:Y_o<=Y;
    endcase
end
reg            de_o,vs_o,data_en_r;
always@(posedge clk)begin
    CB_o<=CB;
    CR_o<=CR;
    vs_o<=post_vs;
    de_o<=post_de;
    data_en_r<=post_data_en;
end
// assign  Y_o=({8{(cnt==3'b000)}}&Y)
//         |   ({8{(cnt==3'b001)}}&Y_o0)
//         |   ({8{(cnt==3'b010)}}&Y_o1)
//         |   ({8{(cnt==3'b011)}}&Y_o2)
//         |   ({8{(cnt==3'b100)}}&Y_o3)
//         |   ({8{(cnt==3'b101)}}&Y_o4)
//         |   ({8{(cnt==3'b110)}}&Y_o5);

wire    [7:0]   r_o,g_o,b_o;

ycbcr_to_rgb ycbcr_to_rgb_duibi(
	.clk(clk),
	.i_y_8b(Y_o),
	.i_cb_8b(CB_o),
	.i_cr_8b(CR_o),
	.i_h_sync(de_o),
	.i_v_sync(vs_o),
	.i_data_en(data_en_r),
	.o_r_8b(r_o),
	.o_g_8b(g_o),
	.o_b_8b(b_o),
	.o_h_sync(pro_de),
	.o_v_sync(pro_vs),                                                                                                    
	.o_data_en(data_en_o)                                                                                                   
);
assign  pro_data={r_o[7:3],g_o[7:2],b_o[7:3]};

endmodule