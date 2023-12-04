module signal_syn (
    input               clk     ,
    input               rst     ,
    input[15:0]         pre_data,
    input               pre_vs  ,
    input               pre_de  ,
    output[15:0]        post_data,
    output              post_de ,
    output              post_vs ,
    output              post_data_en
);
reg    byte_flag,byte_flag_d0;
reg    [15:0]   data_d0,data_d1;
reg    vs_d0,vs_d1,de_d0,de_d1;


reg    frame_val_flag;

wire   pos_vsync;            //采输入场同步信号的上升沿

assign pos_vsync = (~vs_d1) & vs_d0;

always @(posedge clk or negedge rst) begin
    if(!rst)
        frame_val_flag <= 1'b0;
    else if(pos_vsync)
        frame_val_flag <= 1'b1;
    else;    
end 

always @(posedge clk or negedge rst) begin
    if(!rst)
        byte_flag<=1'b0;
    else if(pre_de) begin
        byte_flag <= ~byte_flag;    
    end
    else begin
        byte_flag <= 1'b0;
    end    
end        

always @(posedge clk or negedge rst) begin
    if(!rst)begin
        data_d0<=0;
        data_d1<=0;
        vs_d0<=0;
        vs_d1<=0;
        de_d0<=0;
        de_d1<=0;
        byte_flag_d0 <= 0;	        
    end
    else begin
        data_d0         <= pre_data ;
        data_d1         <= data_d0  ;
        vs_d0           <= pre_vs   ;
        vs_d1           <= vs_d0;
        de_d0           <= pre_de;
        de_d1           <= de_d0;
        byte_flag_d0    <= byte_flag;	
    end
end 
assign  post_data       = frame_val_flag ? data_d1       :1'b0;
assign  post_vs         = frame_val_flag ? vs_d1         :1'b0;
assign  post_de         = frame_val_flag ? de_d1         :1'b0;
assign  post_data_en    = frame_val_flag ? byte_flag_d0  :1'b0;    
endmodule