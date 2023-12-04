module bright  (
    input                   clk         ,
    input                   rst         ,
    input[15:0]             rgb_data_i  ,
    input                   data_en_i   ,
    output                  data_en_o   ,
    input                   key_in      ,
    input                   vs_in       ,
    input                   de_in       ,
    output[15:0]            rgb_data_o  ,
    output                  vs_o        ,
    output                  de_o
);
wire    key_flag;
wire[7:0]   r,g,b;
assign  r={rgb_data_i[15:11],3'b000};
assign  g={rgb_data_i[10:5],2'b00};
assign  b={rgb_data_i[4:0],3'b000};
reg[7:0]   r_o,g_o,b_o;

key_filter		
#
(
	.CNT_MAX(20'd999_999)
)key_filter
(
	.sys_clk	(clk        ),
	.sys_rst_n	(rst        ),
	.key_in		(key_in     ),
	.key_flag	(key_flag   )
);


reg    vs_d,de_d,data_en_d;
always @(posedge clk) begin
    vs_d<=vs_in;
    de_d<=de_in;
    data_en_d<=data_en_i;
end

reg     [2:0]cnt=0;
always @(posedge clk) begin
    if(key_flag)
        cnt<=cnt+1'b1;
    else 
        cnt<=cnt;
end
always @(posedge clk ) begin
    case(cnt)
        3'b000:
        begin
            r_o<=r;
            g_o<=g;
            b_o<=b;
        end
        3'b001:
        begin
            r_o<=(r>10)?(r-10):8'b0;
            g_o<=(g>10)?(g-10):8'b0;
            b_o<=(b>10)?(b-10):8'b0;
        end
        3'b010:
        begin
            r_o<=(r>20)?(r-20):8'b0;
            g_o<=(g>20)?(g-20):8'b0;
            b_o<=(b>20)?(b-20):8'b0;
        end
        3'b011:
        begin
            r_o<=(r>30)?(r-30):8'b0;
            g_o<=(g>30)?(g-30):8'b0;
            b_o<=(b>30)?(b-30):8'b0;
        end
        3'b100:
        begin
            r_o<=(r>40)?(r-40):8'b0;
            g_o<=(g>40)?(g-40):8'b0;
            b_o<=(b>40)?(b-40):8'b0;            
        end
        3'b101:
        begin
            r_o<=((r+15)<255)?(r+15):8'd255;
            g_o<=((g+15)<255)?(g+15):8'd255;
            b_o<=((b+15)<255)?(b+15):8'd255;
        end
        3'b110:
        begin
            r_o<=((r+30)<255)?(r+30):8'd255;
            g_o<=((g+30)<255)?(g+30):8'd255;
            b_o<=((b+30)<255)?(b+30):8'd255;            
        end
        3'b111:
        begin
            r_o<=((r+45)<255)?(r+45):8'd255;
            g_o<=((g+45)<255)?(g+45):8'd255;
            b_o<=((b+45)<255)?(b+45):8'd255;            
        end
        default:begin
            r_o<=r;
            g_o<=g;
            b_o<=b;
        end
    endcase
end
assign  vs_o=vs_d;
assign  de_o=de_d;
assign  data_en_o=data_en_d;
assign  rgb_data_o={r_o[7:3],g_o[7:2],b_o[7:3]};

endmodule