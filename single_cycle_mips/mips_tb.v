module mips_tb;

	reg	clk, reset;

	mips_single my_mips (clk, reset);

	initial
	begin
		clk = 0;
		reset = 1;
		#50;
		reset = 0;
	end;

	always #100 clk = ~clk;

endmodule