//****************************************Copyright (c)***********************************//
//Ô­×Ó¸çÔÚÏß½ÌÑ§Æ½Ì¨£ºwww.yuanzige.com
//¼¼ÊõÖ§³Ö£ºwww.openedv.com
//ÌÔ±¦µêÆÌ£ºhttp://openedv.taobao.com 
//¹Ø×¢Î¢ĞÅ¹«ÖÚÆ½Ì¨Î¢ĞÅºÅ£º"ÕıµãÔ­×Ó"£¬Ãâ·Ñ»ñÈ¡ZYNQ & FPGA & STM32 & LINUX×ÊÁÏ¡£
//°æÈ¨ËùÓĞ£¬µÁ°æ±Ø¾¿¡£
//Copyright(C) ÕıµãÔ­×Ó 2018-2028
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           eth_top
// Last modified Date:  2020/2/18 9:20:14
// Last Version:        V1.0
// Descriptions:        ÒÔÌ«ÍøÍ¨ĞÅUDPÍ¨ĞÅ»·»Ø¶¥²ãÄ£¿é
//----------------------------------------------------------------------------------------
// Created by:          ÕıµãÔ­×Ó
// Created date:        2020/2/18 9:20:14
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module eth_top(
    input              sys_rst_n      ,  //ÏµÍ³¸´Î»ĞÅºÅ£¬µÍµçÆ½ÓĞĞ§ 
    input              sys_clk        ,
    //ÒÔÌ«ÍøRGMII½Ó¿Ú            
    /*
    input              eth_rxc        ,  //RGMII½ÓÊÕÊı¾İÊ±ÖÓ
    input              eth_rx_ctl     ,  //RGMIIÊäÈëÊı¾İÓĞĞ§ĞÅºÅ
    input  [3:0]       eth_rxd        ,  //RGMIIÊäÈëÊı¾İ
    output             eth_txc        ,  //RGMII·¢ËÍÊı¾İÊ±ÖÓ    
    output             eth_tx_ctl     ,  //RGMIIÊä³öÊı¾İÓĞĞ§ĞÅºÅ
    output [3:0]       eth_txd        ,  //RGMIIÊä³öÊı¾İ          
    output             eth_rst_n      ,  //ÒÔÌ«ÍøĞ¾Æ¬¸´Î»ĞÅºÅ£¬µÍµçÆ½ÓĞĞ§ 
    */
    output  [7:0]   gmii_txd    , //GMIIå‘é€æ•°æ®
    output          gmii_tx_en  , //GMIIå‘é€æ•°æ®ä½¿èƒ½ä¿¡å·
    output          gmii_tx_clk ,//GMIIå‘é€æ—¶é’Ÿ
    input  [7:0]    gmii_rxd    , //GMIIæ¥æ”¶æ•°æ® 
    input           gmii_rx_dv  , //GMIIæ¥æ”¶æ•°æ®æœ‰æ•ˆä¿¡å·
    input           gmii_rx_clk , //GMIIæ¥æ”¶æ—¶é’Ÿ
    output          gmii_tx_er  ,
    input           gmii_rx_er  ,
    output          eth_rst_n   ,   //ä»¥å¤ªç½‘èŠ¯ç‰‡å¤ä½ä¿¡å·ï¼Œä½ç”µå¹³æœ‰æ•ˆ
    input              udp_tx_start_en,  //ÒÔÌ«Íø¿ªÊ¼·¢ËÍĞÅºÅ   
    input  [31:0]      tx_data        ,  //ÒÔÌ«Íø´ı·¢ËÍÊı¾İ     
    input  [15:0]      tx_byte_num    ,  //ÒÔÌ«Íø·¢ËÍµÄÓĞĞ§×Ö½ÚÊı µ¥Î»:byte 
    output             udp_tx_done    ,  //UDP·¢ËÍÍê³ÉĞÅºÅ  
    output             tx_req         ,  //¶ÁÊı¾İÇëÇóĞÅºÅ    
    output             rec_pkt_done   ,  
    output             rec_en         ,         
    output [31:0]      rec_data       ,  //UDP½ÓÊÕµÄÊı¾İ
    output [15:0]      rec_byte_num      //UDP½ÓÊÕµ½µÄ×Ö½ÚÊı
);

//parameter define
//¿ª·¢°åMACµØÖ· 00-11-22-33-44-55
parameter  BOARD_MAC = 48'h00_11_22_33_44_55;     
//¿ª·¢°åIPµØÖ· 192.168.1.10
parameter  BOARD_IP  = {8'd192,8'd168,8'd1,8'd10};  
//Ä¿µÄMACµØÖ· ff_ff_ff_ff_ff_ff
parameter  DES_MAC   = 48'hff_ff_ff_ff_ff_ff;    
//Ä¿µÄIPµØÖ· 192.168.1.102     
parameter  DES_IP    = {8'd192,8'd168,8'd1,8'd102};  

//wire define
/*           
wire          gmii_rx_dv ; //GMII½ÓÊÕÊı¾İÓĞĞ§ĞÅºÅ
wire  [7:0]   gmii_rxd   ; //GMII½ÓÊÕÊı¾İ
wire          gmii_tx_en ; //GMII·¢ËÍÊı¾İÊ¹ÄÜĞÅºÅ
wire  [7:0]   gmii_txd   ; //GMII·¢ËÍÊı¾İ 
*/    
wire          arp_gmii_tx_en; //ARP GMIIÊä³öÊı¾İÓĞĞ§ĞÅºÅ 
wire  [7:0]   arp_gmii_txd  ; //ARP GMIIÊä³öÊı¾İ
wire          arp_rx_done   ; //ARP½ÓÊÕÍê³ÉĞÅºÅ
wire          arp_rx_type   ; //ARP½ÓÊÕÀàĞÍ 0:ÇëÇó  1:Ó¦´ğ
wire  [47:0]  src_mac       ; //½ÓÊÕµ½Ä¿µÄMACµØÖ·
wire  [31:0]  src_ip        ; //½ÓÊÕµ½Ä¿µÄIPµØÖ·    
wire          arp_tx_en     ; //ARP·¢ËÍÊ¹ÄÜĞÅºÅ
wire          arp_tx_type   ; //ARP·¢ËÍÀàĞÍ 0:ÇëÇó  1:Ó¦´ğ
wire  [47:0]  des_mac       ; //·¢ËÍµÄÄ¿±êMACµØÖ·
wire  [31:0]  des_ip        ; //·¢ËÍµÄÄ¿±êIPµØÖ·   
wire          arp_tx_done   ; //ARP·¢ËÍÍê³ÉĞÅºÅ
wire          udp_gmii_tx_en; //UDP GMIIÊä³öÊı¾İÓĞĞ§ĞÅºÅ 
wire  [7:0]   udp_gmii_txd  ; //UDP GMIIÊä³öÊı¾İ

//*****************************************************
//**                    main code
//*****************************************************

assign des_mac = src_mac;
assign des_ip = src_ip;
assign eth_rst_n = sys_rst_n;
//assign gmii_tx_clk = gmii_rx_clk;
assign gmii_tx_er = 1'b0;
    Gowin_rPLL tx_clk_inst(
        .clkout(gmii_tx_clk), //output clkout
        .clkin(sys_clk) //input clkin
    );
//GMII½Ó¿Ú×ªRGMII½Ó¿Ú
/*
gmii_to_rgmii  u_gmii_to_rgmii(
    .gmii_rx_clk   (gmii_rx_clk ),
    .gmii_rx_dv    (gmii_rx_dv  ),
    .gmii_rxd      (gmii_rxd    ),
    .gmii_tx_clk   (gmii_tx_clk ),
    .gmii_tx_en    (gmii_tx_en  ),
    .gmii_txd      (gmii_txd    ),
    
    .rgmii_rxc     (eth_rxc     ),
    .rgmii_rx_ctl  (eth_rx_ctl  ),
    .rgmii_rxd     (eth_rxd     ),
    .rgmii_txc     (eth_txc     ),
    .rgmii_tx_ctl  (eth_tx_ctl  ),
    .rgmii_txd     (eth_txd     )
    );
*/
//ARPÍ¨ĞÅ
arp                                             
   #(
    .BOARD_MAC     (BOARD_MAC),      //²ÎÊıÀı»¯
    .BOARD_IP      (BOARD_IP ),
    .DES_MAC       (DES_MAC  ),
    .DES_IP        (DES_IP   )
    )
   u_arp(
    .rst_n         (sys_rst_n  ),
                    
    .gmii_rx_clk   (gmii_rx_clk),
    .gmii_rx_dv    (gmii_rx_dv ),
    .gmii_rxd      (gmii_rxd   ),
    .gmii_tx_clk   (gmii_tx_clk),
    .gmii_tx_en    (arp_gmii_tx_en ),
    .gmii_txd      (arp_gmii_txd),
                    
    .arp_rx_done   (arp_rx_done),
    .arp_rx_type   (arp_rx_type),
    .src_mac       (src_mac    ),
    .src_ip        (src_ip     ),
    .arp_tx_en     (arp_tx_en  ),
    .arp_tx_type   (arp_tx_type),
    .des_mac       (des_mac    ),
    .des_ip        (des_ip     ),
    .tx_done       (arp_tx_done)
    );

//UDPÍ¨ĞÅ
udp                                             
   #(
    .BOARD_MAC     (BOARD_MAC),      //²ÎÊıÀı»¯
    .BOARD_IP      (BOARD_IP ),
    .DES_MAC       (DES_MAC  ),
    .DES_IP        (DES_IP   )
    )
   u_udp(
    .rst_n         (sys_rst_n   ),  
    
    .gmii_rx_clk   (gmii_rx_clk ),           
    .gmii_rx_dv    (gmii_rx_dv  ),         
    .gmii_rxd      (gmii_rxd    ),                   
    .gmii_tx_clk   (gmii_tx_clk ), 
    .gmii_tx_en    (udp_gmii_tx_en),         
    .gmii_txd      (udp_gmii_txd),  

    .rec_pkt_done  (rec_pkt_done),    
    .rec_en        (rec_en      ),     
    .rec_data      (rec_data    ),         
    .rec_byte_num  (rec_byte_num),      
    .tx_start_en   (udp_tx_start_en ),        
    .tx_data       (tx_data     ),         
    .tx_byte_num   (tx_byte_num ),  
    .des_mac       (des_mac     ),
    .des_ip        (des_ip      ),    
    .tx_done       (udp_tx_done ),        
    .tx_req        (tx_req      )           
    ); 
    
//ÒÔÌ«Íø¿ØÖÆÄ£¿é
eth_ctrl u_eth_ctrl(
    .clk            (gmii_rx_clk),
    .rst_n          (sys_rst_n),

    .arp_rx_done    (arp_rx_done   ),
    .arp_rx_type    (arp_rx_type   ),
    .arp_tx_en      (arp_tx_en     ),
    .arp_tx_type    (arp_tx_type   ),
    .arp_tx_done    (arp_tx_done   ),
    .arp_gmii_tx_en (arp_gmii_tx_en),
    .arp_gmii_txd   (arp_gmii_txd  ),
    
    .udp_tx_start_en(udp_tx_start_en),
    .udp_tx_done    (udp_tx_done   ),    
    .udp_gmii_tx_en (udp_gmii_tx_en),
    .udp_gmii_txd   (udp_gmii_txd  ),
                     
    .gmii_tx_en     (gmii_tx_en    ),
    .gmii_txd       (gmii_txd      )
    );

endmodule