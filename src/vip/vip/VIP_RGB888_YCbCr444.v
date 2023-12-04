module VIP_RGB888_YCbCr444
(
    //global clock
    input               clk,                //cmos video pixel clock
    input               rst_n,              //global reset

    //Image data prepred to be processed
    input               per_img_vsync,      //Prepared Image data vsync valid signal
    input               per_img_href,       //Prepared Image data href vaild signal
    input       [7:0]   per_img_red,        //Prepared Image red data to be processed
    input       [7:0]   per_img_green,      //Prepared Image green data to be processed
    input       [7:0]   per_img_blue,       //Prepared Image blue data to be processed
    input               data_en_i   ,
    output              data_en_o   ,
    
    //Image data has been processed
    output              post_img_vsync,     //Processed Image data vsync valid signal
    output              post_img_href,      //Processed Image data href vaild signal
    output      [7:0]   post_img_Y,         //Processed Image brightness output
    output      [7:0]   post_img_Cb,        //Processed Image blue shading output
    output      [7:0]   post_img_Cr         //Processed Image red shading output
);

//Step 1
reg [15:0]  img_red_r0,   img_red_r1,   img_red_r2; 
reg [15:0]  img_green_r0, img_green_r1, img_green_r2; 
reg [15:0]  img_blue_r0,  img_blue_r1,  img_blue_r2; 
always@(posedge clk)
begin
    img_red_r0   <= per_img_red   * 8'd76;
    img_red_r1   <= per_img_red   * 8'd43;  
    img_red_r2   <= per_img_red   * 8'd128;
    img_green_r0 <= per_img_green * 8'd150;
    img_green_r1 <= per_img_green * 8'd84;
    img_green_r2 <= per_img_green * 8'd107;
    img_blue_r0  <= per_img_blue  * 8'd29;
    img_blue_r1  <= per_img_blue  * 8'd128;
    img_blue_r2  <= per_img_blue  * 8'd20;
end

//--------------------------------------------------
//Step 2
reg [15:0]  img_Y_r0;   
reg [15:0]  img_Cb_r0; 
reg [15:0]  img_Cr_r0; 
always@(posedge clk)
begin
    img_Y_r0  <= img_red_r0  + img_green_r0 + img_blue_r0;
    img_Cb_r0 <= img_blue_r1 - img_red_r1   - img_green_r1 +  16'd32768;
    img_Cr_r0 <= img_red_r2  - img_green_r2 - img_blue_r2  +  16'd32768;
end


//--------------------------------------------------
//Step 3
reg [7:0] img_Y_r1; 
reg [7:0] img_Cb_r1; 
reg [7:0] img_Cr_r1; 
always@(posedge clk)
begin
    img_Y_r1  <= img_Y_r0[15:8];
    img_Cb_r1 <= img_Cb_r0[15:8];
    img_Cr_r1 <= img_Cr_r0[15:8]; 
end

//------------------------------------------
//lag 3 clocks signal sync  
reg [2:0] per_img_vsync_r;
reg [2:0] per_img_href_r;
reg [2:0] data_en_i_r;   
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        begin
        per_img_vsync_r <= 0;
        per_img_href_r <= 0;
        data_en_i_r<=0;
        end
    else
        begin
        data_en_i_r     <=  {data_en_i_r[1:0],data_en_i};
        per_img_vsync_r <=  {per_img_vsync_r[1:0],  per_img_vsync};
        per_img_href_r  <=  {per_img_href_r[1:0],   per_img_href};
        end
end
assign  post_img_vsync = per_img_vsync_r[2];
assign  post_img_href  = per_img_href_r[2];
assign  data_en_o      = data_en_i_r[2];
assign  post_img_Y     = post_img_href ? img_Y_r1 : 8'd0;
assign  post_img_Cb    = post_img_href ? img_Cb_r1: 8'd0;
assign  post_img_Cr    = post_img_href ? img_Cr_r1: 8'd0;


endmodule
