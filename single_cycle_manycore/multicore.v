// Multicore System Design @ Hallym University
// HCore Team
// Park Ji-Su, Yun-Mi Lee
//

module multicore(	input	iCLK_50,
					input	[3:0]	iSW,
					output	[7:0]	oHEX0_D, oHEX1_D, oHEX2_D, oHEX3_D, oHEX4_D, oHEX5_D, oHEX6_D, oHEX7_D,
					output	[4:0]	oLEDR
					);

	// internal signals for communications between cores and shared memeory
	wire clk;
	wire sbit1, rd1, wr1, sbit2, rd2, wr2, sbit3, rd3, wr3, sbit4, rd4, wr4;
	wire [31:0] addr1, todata1, addr2, todata2, addr3, todata3, addr4, todata4, fromdata;
	wire [31:0] addr, data;
	wire mem_read, mem_write, sharedAccess;
	wire halt1, halt2, halt3, halt4, multicoreHalt;
	wire [5:0] opout1, opout2, opout3, opout4;

	wire [31:0] finalResult, fR1, fR2, fR3, fR4, check;
	reg	[31:0]	clkCnt, EndCnt;
	reg [31:0]	display;
	
	assign clk = iCLK_50;
	assign reset = iSW[0];
	assign multicoreHalt = halt1 & halt2 & halt3 & halt4;
	assign oLEDR[4] = multicoreHalt;
	assign oLEDR[3] = halt4;
	assign oLEDR[2] = halt3;
	assign oLEDR[1] = halt2;
	assign oLEDR[0] = halt1;
	
	DISPSEG	display7seg1 (opout1[3:0], oHEX0_D);  // End Address = 31 = 0000_0000_0001_(1111), (1111) = F
	DISPSEG	display7seg2 (opout2[3:0], oHEX1_D);  // End Address = 22 = 0000_0000_0001_(0110), (0110) = 6
	DISPSEG	display7seg3 (opout3[3:0], oHEX2_D);  // End Address = 23 = 0000_0000_0001_(0111), (0111) = 7
	DISPSEG	display7seg4 (opout4[3:0], oHEX3_D);  // End Address = 24 = 0000_0000_0001_(1000), (1000) = 8
	
	//
	// Cores for a Multicore system
	mips_single1 #(1) core1  (clk, reset, sbit1, addr1, todata1, rd1, wr1, fromdata, halt1, opout1);
	mips_single2 #(2) core2  (clk, reset, sbit2, addr2, todata2, rd2, wr2, fromdata, halt2, opout2);
	mips_single3 #(3) core3  (clk, reset, sbit3, addr3, todata3, rd3, wr3, fromdata, halt3, opout3);
	mips_single4 #(4) core4  (clk, reset, sbit4, addr4, todata4, rd4, wr4, fromdata, halt4, opout4);
	
	// Shared Memory & Its controller
	sharedMem32  smem  (clk, mem_read, mem_write, addr, data, fromdata, sharedAccess, finalResult, fR1, fR2, fR3, fR4);
	
	sharedMemArbiter   arbiter ( addr1, todata1, rd1, wr1, sbit1,
                               addr2, todata2, rd2, wr2, sbit2,
                               addr3, todata3, rd3, wr3, sbit3,
                               addr4, todata4, rd4, wr4, sbit4,
                               addr, data, mem_read, mem_write, sharedAccess );
                               
                               
	// Measure clock count
	always @( posedge clk )
	begin
		if( reset )
		begin
			clkCnt <= 0;
			EndCnt <= 0;
		end
		else if ( ~multicoreHalt )
			clkCnt <= clkCnt + 1;
		else
		begin
			EndCnt <= clkCnt;
		end
	end
	
	// Display clock count and other DEBUG information
	always @( * )
	begin
		case ( iSW[3:1] )
		3'b000 : display = EndCnt;
		3'b001 : display = fR1;				// 325 = HEX 145
		3'b010 : display = fR2;				// 950 = HEX 3B6 
		3'b100 : display = fR3;				// 1575= HEX 627 
		3'b011 : display = fR4;				// 2200= HEX 898
		3'b111 : display = finalResult;		// 5050= HEX 13BA
		default : display = 32`hFFFF;			// Un-supported Switch Config: HEX FFFF
		endcase
	end						
	
	DISPSEG	display7segclk1 (display[3:0], oHEX4_D); 
	DISPSEG	display7segclk2 (display[7:4], oHEX5_D);
	DISPSEG	display7segclk3 (display[11:8], oHEX6_D);
	DISPSEG	display7segclk4 (display[15:12], oHEX7_D);
endmodule

module DISPSEG (realq,dis_seg);
	input [3:0] realq;
	output reg [6:0] dis_seg;    

	always @( realq ) begin
		case(realq)
		4'h0 : dis_seg <= 7'b1000000;
		4'h1 : dis_seg <= 7'b1111001;
		4'h2 : dis_seg <= 7'b0100100;
		4'h3 : dis_seg <= 7'b0110000;
		4'h4 : dis_seg <= 7'b0011001;
		4'h5 : dis_seg <= 7'b0010010;
		4'h6 : dis_seg <= 7'b0000010;
		4'h7 : dis_seg <= 7'b1111000;
		4'h8 : dis_seg <= 7'b0000000;
		4'h9 : dis_seg <= 7'b0010000;
		4'ha : dis_seg <= 7'b0001000;
        4'hb : dis_seg <= 7'b0000011;
        4'hc : dis_seg <= 7'b1000110;
        4'hd : dis_seg <= 7'b0100001;
        4'he : dis_seg <= 7'b0000110;
        4'hf : dis_seg <= 7'b0001110;
		endcase
	end
endmodule