// Simple Example showing a movement of a LED bar
module segdisplay(oHEX0_D, oHEX1_D, oHEX2_D, oHEX3_D);

	output [6:0] oHEX0_D, oHEX1_D, oHEX2_D, oHEX3_D;
	
	// HELO
	assign oHEX0_D = 7'b111_1110;
	assign oHEX1_D = 7'b111_1101;
	assign oHEX2_D = 7'b111_1011;
	assign oHEX3_D = 7'b111_0111;
endmodule


module segdisplay(iCLK_50, oHEX0_D);

	input iCLK_50;
	output [6:0] oHEX0_D;
	
	reg	[26:0] cnt;
	
	always @( posedge iCLK_50 )
	begin
		cnt = cnt + 1;
	end
	
	move(cnt[26:24], oHEX0_D);
	
endmodule

module move(cnt, HEX0);
	input	[2:0] cnt;
	output	[6:0] HEX0;
	reg	[6:0] HEX0;
	
	always @ (cnt)
	begin
		case (cnt) 
			0 : HEX0 = 7'b111_1110;
			1 : HEX0 = 7'b111_1101;
			2 : HEX0 = 7'b111_1011;
			3 : HEX0 = 7'b111_0111;
			4 : HEX0 = 7'b110_1111;
			5 : HEX0 = 7'b101_1111;
			6 : HEX0 = 7'b011_1111;
			default: HEX0 = 7'b111_1111;
		endcase		
	end
endmodule
