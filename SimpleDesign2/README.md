## README file for Simple Design Example 2
## Moving a LED bar on a 7-segment display.

다음은 1초에 한번씩 7 segment 상의 LED bar를 회전하는 예제입니다.

```verilog
module segdisplay(iCLK_50, oHEX0_D);

	input iCLK_50;
	output [6:0] oHEX0_D;
	
	reg	[26:0] cnt;
	
	// clock이 rising 할때마다 cnt 값을 1씩 증가
	always @( posedge iCLK_50 )
	begin
		cnt = cnt + 1;
	end
	
	move(cnt[26:24], oHEX0_D);
	
endmodule
```


```verilog
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
```

