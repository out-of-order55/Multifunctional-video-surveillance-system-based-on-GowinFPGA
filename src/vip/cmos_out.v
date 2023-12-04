module cmos_out(
    input               clk,
    input               rst_n,

    input               cam_vs0,
    input[15:0]         cam_data0,
    input               cam_de0,
    input               cam_data_en0,
    input               cam_pre_de0,

    input               cam_vs1,
    input               cam_de1,
    input[15:0]         cam_data1,
    input               cam_data_en1,
    input               cam_pre_de1,

    output              cam_de_o,
    output              cam_vs_o,
    output              cam_data_en_o,
    output reg[15:0]        cam_data_o   
);
	parameter IW 		= 1280	;
	parameter IH 		= 480	;	

wire        cam_vs=cam_vs0&cam_vs1;
wire        cam_de=cam_pre_de0&cam_pre_de1;
wire        cam_data_en=cam_data_en0&cam_data_en1;

reg     cam_vs0_r;
always@(posedge clk)	
	if(!rst_n)
        cam_vs0_r<=1'b0;
    else
        cam_vs0_r<=cam_vs0;
assign pose = ~cam_vs0_r&&cam_vs0&&cam_vs1;

reg [15:0] 	hcnt		;
reg [15:0] 	vcnt		;

wire    [15:0]  data1,data0;	
couper_fifo couper_fifo_u0(
		.Data(cam_data1), //input [15:0] Data
		.Clk(clk), //input Clk
		.WrEn(cam_de1), //input WrEn
		.RdEn(rd_en1), //input RdEn
		.Reset(~rst_n), //input Reset
		.Q(data1), //output [15:0] Q
		.Empty(), //output Empty
		.Full() //output Full
);
// couper_fifo couper_fifo_u1(
// 		.Data(cam_data1), //input [15:0] Data
// 		.Clk(clk), //input Clk
// 		.WrEn(cam_de1), //input WrEn
// 		.RdEn(rd_en0), //input RdEn
// 		.Reset(~rst_n), //input Reset
// 		.Q(data0), //output [15:0] Q
// 		.Empty(), //output Empty
// 		.Full() //output Full
// );
// 	// fifo_3 fifo_u3(
// 	// 	.Data(cam_data2), //input [15:0] Data
// 	// 	.Clk(Clk), //input Clk
// 	// 	.WrEn(cam_de2), //input WrEn
// 	// 	.RdEn(rd_en2), //input RdEn
// 	// 	.Reset(~rst_n), //input Reset
// 	// 	.Q(data2), //output [15:0] Q
// 	// 	.Empty(Empty_o), //output Empty
// 	// 	.Full(Full_o) //output Full
// 	// );

// couper_fifo couper_fifo_u1(
// 		.Data(cam_data1), //input [15:0] Data
// 		.Clk(clk), //input Clk
// 		.WrEn(cam_de2), //input WrEn
// 		.RdEn(rd_en3), //input RdEn
// 		.Reset(~rst_n), //input Reset
// 		.Q(data3), //output [15:0] Q
// 		.Empty(), //output Empty
// 		.Full() //output Full
// );
reg [1:0]   vs_r,de_r,data_en_r;
always@(posedge clk)begin
    if(!rst_n)begin
        vs_r<=1'b0;
        de_r<=1'b0;
        data_en_r<=1'b0;
    end
    else    begin
        vs_r<={vs_r[0],cam_vs               };
        de_r<={de_r[0],cam_de               };
        data_en_r<={data_en_r[0],cam_data_en};
    end
end
always@(posedge clk)	
	if(!rst_n)
		hcnt <= 'd0;
	else if(cam_de==1'b1)
		hcnt <= hcnt + 1'b1;
	else
		hcnt <= 'd0;

always@(posedge clk)	
	if(!rst_n)
		vcnt <= 'd0;
	else if(pose==1'b1)
		vcnt <= 'd0;
	else if(hcnt==IW-1&&vcnt==IH-1)
		vcnt <= 'd0;
	else if(hcnt==IW-1)
		vcnt <= vcnt + 1'b1;
	else
		vcnt <= vcnt;



reg     rd_en0,rd_en1,rd_en2;
always@(posedge clk)
    if(!rst_n)
        rd_en0<=1'b0;
    else    if(hcnt>=0&&hcnt<=640&&vcnt>=0&&vcnt<=480)
        rd_en0<=1'b1;
    else
        rd_en0<=1'b0;

always@(posedge clk)
    if(!rst_n)
        rd_en1<=1'b0;
    else    if(hcnt>=640&&hcnt<=1280&&vcnt>=0&&vcnt<=480)
        rd_en1<=1'b1;
    else
        rd_en1<=1'b0;


always @(posedge clk) begin
    if(rd_en0)
        cam_data_o<=cam_data0;
    else if(rd_en1)
        cam_data_o<=data1;

end

assign      cam_data_en_o= data_en_r[1];
assign      cam_vs_o     = vs_r[1];
assign      cam_de_o     = de_r[1];

endmodule