This directory includes few files for experiencing simple circuit design and simulation.

```verilog
// myand.v
module intelFPGA (in1, in2, out);
	input in1, in2;
	output out;

	assign out = in1 & in2;

endmodule
```

```verilog
// Test_tb.v
`timescale 1ns / 10ps

module Test_tb;

	reg	in1, in2;
	wire	out;

	myand mydesign (in1, in2, out);
	
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


```verilog
`timescale 1ns / 10ps

module Test_tb;

	reg	clk;
	reg	in1, in2;
	wire	out;
	reg	out_expected;
	reg  [31:0] vectornum, errors;    // bookkeeping variables
	reg  [2:0]  testvectors[10:0]; // array of testvectors
	

	intelFPGA mydesign (in1, in2, out);


	// generate clock
	always     // no sensitivity list, so it always executes
   begin
      clk = 1; #5; clk = 0; #5;
   end
	 
	initial
	begin
      $readmemb("example.tv", testvectors);
      vectornum = 0; errors = 0;
	end

	// apply test vectors on rising edge of clk
	always @(posedge clk)
   begin
		#1; {in1, in2, out_expected} = testvectors[vectornum];
   end

	// check results on falling edge of clk
   always @(negedge clk)
	begin
		if (out !== out_expected) begin  
			$display("Error: inputs = %b", {in1, in2});
			$display("  outputs = %b (%b expected)", out, out_expected);
			errors = errors + 1;
      end

	// Note: to print in hexadecimal, use %h. For example,
	//       $display(“Error: inputs = %h”, {a, b, c});
	   vectornum = vectornum + 1;
		
      if (testvectors[vectornum] === 4'bx) begin 
			$display("%d tests completed with %d errors", vectornum, errors);
			$finish;
      end
		
	end
	
endmodule
```
