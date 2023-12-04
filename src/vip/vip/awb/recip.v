`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/09/15 17:41:29
// Design Name: 
// Module Name: recip
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module recip(
	input 		[7:0] 	ava		,
	output reg 	[15:0]	recip	
);

always@(*)
	begin
		case(ava)
		8'd0:  	recip = 16'h0000;
		8'd1:  	recip = 16'hffff;
		8'd2:  	recip = 16'h8000;
		8'd3:  	recip = 16'h5555;
		8'd4:  	recip = 16'h4000;
		8'd5:  	recip = 16'h3333;
		8'd6:  	recip = 16'h2aaa;
		8'd7:  	recip = 16'h2492;
		8'd8:  	recip = 16'h2000;
		8'd9:  	recip = 16'h1c71;
		8'd10: 	recip = 16'h1999;
		8'd11: 	recip = 16'h1745;
		8'd12: 	recip = 16'h1555;
		8'd13: 	recip = 16'h13b1;
		8'd14: 	recip = 16'h1249;
		8'd15: 	recip = 16'h1111;
		8'd16: 	recip = 16'h1000;
		8'd17: 	recip = 16'h0f0f;
		8'd18: 	recip = 16'h0e38;
		8'd19: 	recip = 16'h0d79;
		8'd20: 	recip = 16'h0ccc;
		8'd21: 	recip = 16'h0c30;
		8'd22: 	recip = 16'h0ba2;
		8'd23: 	recip = 16'h0b21;
		8'd24: 	recip = 16'h0aaa;
		8'd25: 	recip = 16'h0a3d;
		8'd26: 	recip = 16'h09d8;
		8'd27: 	recip = 16'h097b;
		8'd28: 	recip = 16'h0924;
		8'd29: 	recip = 16'h08d3;
		8'd30: 	recip = 16'h0888;
		8'd31: 	recip = 16'h0842;
		8'd32: 	recip = 16'h0800;
		8'd33: 	recip = 16'h07c1;
		8'd34: 	recip = 16'h0787;
		8'd35: 	recip = 16'h0750;
		8'd36: 	recip = 16'h071c;
		8'd37: 	recip = 16'h06eb;
		8'd38: 	recip = 16'h06bc;
		8'd39: 	recip = 16'h0690;
		8'd40: 	recip = 16'h0666;
		8'd41: 	recip = 16'h063e;
		8'd42: 	recip = 16'h0618;
		8'd43: 	recip = 16'h05f4;
		8'd44: 	recip = 16'h05d1;
		8'd45: 	recip = 16'h05b0;
		8'd46: 	recip = 16'h0590;
		8'd47: 	recip = 16'h0572;
		8'd48: 	recip = 16'h0555;
		8'd49: 	recip = 16'h0539;
		8'd50: 	recip = 16'h051e;
		8'd51: 	recip = 16'h0505;
		8'd52: 	recip = 16'h04ec;
		8'd53: 	recip = 16'h04d4;
		8'd54: 	recip = 16'h04bd;
		8'd55: 	recip = 16'h04a7;
		8'd56: 	recip = 16'h0492;
		8'd57: 	recip = 16'h047d;
		8'd58: 	recip = 16'h0469;
		8'd59: 	recip = 16'h0456;
		8'd60: 	recip = 16'h0444;
		8'd61: 	recip = 16'h0432;
		8'd62: 	recip = 16'h0421;
		8'd63: 	recip = 16'h0410;
		8'd64: 	recip = 16'h0400;
		8'd65: 	recip = 16'h03f0;
		8'd66: 	recip = 16'h03e0;
		8'd67: 	recip = 16'h03d2;
		8'd68: 	recip = 16'h03c3;
		8'd69: 	recip = 16'h03b5;
		8'd70: 	recip = 16'h03a8;
		8'd71: 	recip = 16'h039b;
		8'd72: 	recip = 16'h038e;
		8'd73: 	recip = 16'h0381;
		8'd74: 	recip = 16'h0375;
		8'd75: 	recip = 16'h0369;
		8'd76: 	recip = 16'h035e;
		8'd77: 	recip = 16'h0353;
		8'd78: 	recip = 16'h0348;
		8'd79: 	recip = 16'h033d;
		8'd80: 	recip = 16'h0333;
		8'd81: 	recip = 16'h0329;
		8'd82: 	recip = 16'h031f;
		8'd83: 	recip = 16'h0315;
		8'd84: 	recip = 16'h030c;
		8'd85: 	recip = 16'h0303;
		8'd86: 	recip = 16'h02fa;
		8'd87: 	recip = 16'h02f1;
		8'd88: 	recip = 16'h02e8;
		8'd89: 	recip = 16'h02e0;
		8'd90: 	recip = 16'h02d8;
		8'd91: 	recip = 16'h02d0;
		8'd92: 	recip = 16'h02c8;
		8'd93: 	recip = 16'h02c0;
		8'd94: 	recip = 16'h02b9;
		8'd95: 	recip = 16'h02b1;
		8'd96: 	recip = 16'h02aa;
		8'd97: 	recip = 16'h02a3;
		8'd98: 	recip = 16'h029c;
		8'd99: 	recip = 16'h0295;
		8'd100: recip = 16'h028f;
		8'd101: recip = 16'h0288;
		8'd102: recip = 16'h0282;
		8'd103: recip = 16'h027c;
		8'd104: recip = 16'h0276;
		8'd105: recip = 16'h0270;
		8'd106: recip = 16'h026a;
		8'd107: recip = 16'h0264;
		8'd108: recip = 16'h025e;
		8'd109: recip = 16'h0259;
		8'd110: recip = 16'h0253;
		8'd111: recip = 16'h024e;
		8'd112: recip = 16'h0249;
		8'd113: recip = 16'h0243;
		8'd114: recip = 16'h023e;
		8'd115: recip = 16'h0239;
		8'd116: recip = 16'h0234;
		8'd117: recip = 16'h0230;
		8'd118: recip = 16'h022b;
		8'd119: recip = 16'h0226;
		8'd120: recip = 16'h0222;
		8'd121: recip = 16'h021d;
		8'd122: recip = 16'h0219;
		8'd123: recip = 16'h0214;
		8'd124: recip = 16'h0210;
		8'd125: recip = 16'h020c;
		8'd126: recip = 16'h0208;
		8'd127: recip = 16'h0204;
		8'd128: recip = 16'h0200;
		8'd129: recip = 16'h01fc;
		8'd130: recip = 16'h01f8;
		8'd131: recip = 16'h01f4;
		8'd132: recip = 16'h01f0;
		8'd133: recip = 16'h01ec;
		8'd134: recip = 16'h01e9;
		8'd135: recip = 16'h01e5;
		8'd136: recip = 16'h01e1;
		8'd137: recip = 16'h01de;
		8'd138: recip = 16'h01da;
		8'd139: recip = 16'h01d7;
		8'd140: recip = 16'h01d4;
		8'd141: recip = 16'h01d0;
		8'd142: recip = 16'h01cd;
		8'd143: recip = 16'h01ca;
		8'd144: recip = 16'h01c7;
		8'd145: recip = 16'h01c3;
		8'd146: recip = 16'h01c0;
		8'd147: recip = 16'h01bd;
		8'd148: recip = 16'h01ba;
		8'd149: recip = 16'h01b7;
		8'd150: recip = 16'h01b4;
		8'd151: recip = 16'h01b2;
		8'd152: recip = 16'h01af;
		8'd153: recip = 16'h01ac;
		8'd154: recip = 16'h01a9;
		8'd155: recip = 16'h01a6;
		8'd156: recip = 16'h01a4;
		8'd157: recip = 16'h01a1;
		8'd158: recip = 16'h019e;
		8'd159: recip = 16'h019c;
		8'd160: recip = 16'h0199;
		8'd161: recip = 16'h0197;
		8'd162: recip = 16'h0194;
		8'd163: recip = 16'h0192;
		8'd164: recip = 16'h018f;
		8'd165: recip = 16'h018d;
		8'd166: recip = 16'h018a;
		8'd167: recip = 16'h0188;
		8'd168: recip = 16'h0186;
		8'd169: recip = 16'h0183;
		8'd170: recip = 16'h0181;
		8'd171: recip = 16'h017f;
		8'd172: recip = 16'h017d;
		8'd173: recip = 16'h017a;
		8'd174: recip = 16'h0178;
		8'd175: recip = 16'h0176;
		8'd176: recip = 16'h0174;
		8'd177: recip = 16'h0172;
		8'd178: recip = 16'h0170;
		8'd179: recip = 16'h016e;
		8'd180: recip = 16'h016c;
		8'd181: recip = 16'h016a;
		8'd182: recip = 16'h0168;
		8'd183: recip = 16'h0166;
		8'd184: recip = 16'h0164;
		8'd185: recip = 16'h0162;
		8'd186: recip = 16'h0160;
		8'd187: recip = 16'h015e;
		8'd188: recip = 16'h015c;
		8'd189: recip = 16'h015a;
		8'd190: recip = 16'h0158;
		8'd191: recip = 16'h0157;
		8'd192: recip = 16'h0155;
		8'd193: recip = 16'h0153;
		8'd194: recip = 16'h0151;
		8'd195: recip = 16'h0150;
		8'd196: recip = 16'h014e;
		8'd197: recip = 16'h014c;
		8'd198: recip = 16'h014a;
		8'd199: recip = 16'h0149;
		8'd200: recip = 16'h0147;
		8'd201: recip = 16'h0146;
		8'd202: recip = 16'h0144;
		8'd203: recip = 16'h0142;
		8'd204: recip = 16'h0141;
		8'd205: recip = 16'h013f;
		8'd206: recip = 16'h013e;
		8'd207: recip = 16'h013c;
		8'd208: recip = 16'h013b;
		8'd209: recip = 16'h0139;
		8'd210: recip = 16'h0138;
		8'd211: recip = 16'h0136;
		8'd212: recip = 16'h0135;
		8'd213: recip = 16'h0133;
		8'd214: recip = 16'h0132;
		8'd215: recip = 16'h0130;
		8'd216: recip = 16'h012f;
		8'd217: recip = 16'h012e;
		8'd218: recip = 16'h012c;
		8'd219: recip = 16'h012b;
		8'd220: recip = 16'h0129;
		8'd221: recip = 16'h0128;
		8'd222: recip = 16'h0127;
		8'd223: recip = 16'h0125;
		8'd224: recip = 16'h0124;
		8'd225: recip = 16'h0123;
		8'd226: recip = 16'h0121;
		8'd227: recip = 16'h0120;
		8'd228: recip = 16'h011f;
		8'd229: recip = 16'h011e;
		8'd230: recip = 16'h011c;
		8'd231: recip = 16'h011b;
		8'd232: recip = 16'h011a;
		8'd233: recip = 16'h0119;
		8'd234: recip = 16'h0118;
		8'd235: recip = 16'h0116;
		8'd236: recip = 16'h0115;
		8'd237: recip = 16'h0114;
		8'd238: recip = 16'h0113;
		8'd239: recip = 16'h0112;
		8'd240: recip = 16'h0111;
		8'd241: recip = 16'h010f;
		8'd242: recip = 16'h010e;
		8'd243: recip = 16'h010d;
		8'd244: recip = 16'h010c;
		8'd245: recip = 16'h010b;
		8'd246: recip = 16'h010a;
		8'd247: recip = 16'h0109;
		8'd248: recip = 16'h0108;
		8'd249: recip = 16'h0107;
		8'd250: recip = 16'h0106;
		8'd251: recip = 16'h0105;
		8'd252: recip = 16'h0104;
		8'd253: recip = 16'h0103;
		8'd254: recip = 16'h0102;
		8'd255: recip = 16'h0101;
		default:recip = 16'h0000;
		endcase
	end
endmodule 


