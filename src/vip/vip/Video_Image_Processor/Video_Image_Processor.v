module Video_Image_Processor
#(
    parameter   [10:0]  IMG_HDISP = 11'd640,                            //  640*480
    parameter   [10:0]  IMG_VDISP = 11'd480
)
(
    //  global clock
    input  wire                 clk             ,                       //  cmos video pixel clock
    input  wire                 rst_n           ,                       //  global reset
    
    //  Image data prepred to be processd
    input  wire                 per_img_vsync   ,                       //  Prepared Image data vsync valid signal
    input  wire                 per_img_href    ,                       //  Prepared Image data href vaild  signal
    input  wire     [7:0]       per_img_gray    ,                       //  Prepared Image brightness data
    
    //  Image data has been processd
    output wire                 post_img_vsync  ,                       //  Processed Image data vsync valid signal
    output wire                 post_img_href   ,                       //  Processed Image data href vaild  signal
    output wire     [7:0]       post_img_gray                           //  Processed Image brightness data
);
//----------------------------------------------------------------------
median_filter_proc 
#(
    .IMG_HDISP  (IMG_HDISP  ),
    .IMG_VDISP  (IMG_VDISP  )
)
u_median_filter_proc
(
    .clk            (clk            ),
    .rst_n          (rst_n          ),
    
    //  Image data prepared to be processed
    .per_img_vsync  (per_img_vsync  ),                                  //  Prepared Image data vsync valid signal
    .per_img_href   (per_img_href   ),                                  //  Prepared Image data href vaild  signal
    .per_img_gray   (per_img_gray   ),                                  //  Prepared Image brightness input
    
    //  Image data has been processed
    .post_img_vsync (post_img_vsync ),                                  //  processed Image data vsync valid signal
    .post_img_href  (post_img_href  ),                                  //  processed Image data href vaild  signal
    .post_img_gray  (post_img_gray  )                                   //  processed Image brightness output
);

endmodule
