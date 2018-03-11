module mips_tb;

	reg	clk, reset;
  wire sbit1, rd1, wr1, sbit2, rd2, wr2, sbit3, rd3, wr3, sbit4, rd4, wr4;
  wire [31:0] addr1, todata1, addr2, todata2, addr3, todata3, addr4, todata4, fromdata;
  wire [31:0] addr, data;
  wire mem_read, mem_write, sharedAccess;
  
  // Cores for a Multicore system
	mips_single1 #(1) core1  (clk, reset, sbit1, addr1, todata1, rd1, wr1, fromdata);
	mips_single2 #(2) core2  (clk, reset, sbit2, addr2, todata2, rd2, wr2, fromdata);
	mips_single3 #(3) core3  (clk, reset, sbit3, addr3, todata3, rd3, wr3, fromdata);
	mips_single4 #(4) core4  (clk, reset, sbit4, addr4, todata4, rd4, wr4, fromdata);	
	
	// Shared Memory & Its controller
	sharedMem32  smem  (clk, mem_read, mem_write, addr, data, fromdata, sharedAccess);
	
	sharedMemArbiter   arbiter ( addr1, todata1, rd1, wr1, sbit1,
                               addr2, todata2, rd2, wr2, sbit2,
                               addr3, todata3, rd3, wr3, sbit3,
                               addr4, todata4, rd4, wr4, sbit4,
                               addr, data, mem_read, mem_write, sharedAccess );
                         
	
	initial
	begin
		clk = 0;
		reset = 1;
		#400;
		reset = 0;
		#500000;
		$finish;
	end;

	always #100 clk = ~clk;

endmodule