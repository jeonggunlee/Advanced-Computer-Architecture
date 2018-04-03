This directory includes few files for experiencing simple circuit design and simulation.

```verilog
module intelFPGA (in1, in2, out);
	input in1, in2;
	output out;

	assign out = in1 & in2;

endmodule
```

```verilog
`timescale 1ns / 10ps

module Test_tb;

	reg	in1, in2;
	wire	out;

	intelFPGA mydesign (in1, in2, out);
	
	initial
	begin
		in1 = 0; in2 = 0;
		#100
		in1 = 0; in2 = 1;
		#100
		in1 = 1; in2 = 0;
		#100
		in1 = 1; in2 = 1;
		#100
		$finish;
	end		
endmodule
```
