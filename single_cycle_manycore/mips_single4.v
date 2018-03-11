//
// Multicore @ Hallym University
//-----------------------------------------------------------------------------
// Title         : MIPS Single-Cycle Processor
// Project       : ECE 313 - Computer Organization
//-----------------------------------------------------------------------------
// File          : mips_single.v
// Author        : John Nestor  <nestorj@lafayette.edu>
// Organization  : Lafayette College
//-----------------------------------------------------------------------------
// Description :
//   "Single Cycle" implementation of the MIPS processor subset described in
//   Section 5.4 of "Computer Organization and Design, 3rd ed."
//   by David Patterson & John Hennessey, Morgan Kaufmann, 2004 (COD3e).  
//
//   It implements the equivalent of Figure 5.19 on page 309 of COD3e
//-----------------------------------------------------------------------------

module mips_single4(clk, reset, sharedMEM, tosharedADDR, tosharedDATA, tosharedRD, tosharedWR, fromsharedDATA, Halt, opout);
    parameter coreID=0;
    
    input clk, reset;
    
    //
    // To/From Shared Memory
    //
    output sharedMEM;
    output [31:0] tosharedADDR;
    output [31:0] tosharedDATA;
    output tosharedRD, tosharedWR;
    input  [31:0] fromsharedDATA;
    output Halt;
    output [5:0] opout;

    wire [31:0] wdata;
    wire [31:0] pcOffset;    
    
    // instruction bus
    wire [31:0] instr;

    // break out important fields from instruction
    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [15:0] immed;
    wire [31:0] extend_immed, b_offset;
    wire [25:0] jumpoffset;

    assign opcode = instr[31:26];
    assign opout = pc[7:2];
    assign rs = instr[25:21];
    assign rt = instr[20:16];
    assign rd = instr[15:11];
    assign shamt = instr[10:6];
    assign funct = instr[5:0];
    assign immed = instr[15:0];
    assign jumpoffset = instr[25:0];

    // sign-extender
    assign extend_immed = { {16{immed[15]}}, immed };
    
    // branch offset shifter
    assign b_offset = extend_immed << 2;

    // datapath signals
    wire [4:0] rfile_wn;
    wire [31:0] rfile_rd1, rfile_rd2, rfile_wd, alu_b, alu_out, b_tgt, pc_next,
                pc, pc_incr, br_add_out, dmem_rdata;
    
    // control signals
    wire RegWrite, Branch, PCSrc, RegDst, MemtoReg, MemRead, MemWrite, ALUSrc, Zero;
    wire [1:0] ALUOp;
    wire [2:0] Operation;

    // module instantiations

    reg32   PC(clk, reset, pc_next, pc);

	assign	pcOffset = (Halt) ? 32'd0 : 32'd4;
	 
    add32   PCADD(pc, pcOffset, pc_incr);

    add32   BRADD(pc_incr, b_offset, b_tgt);

    reg_file	#(coreID) RFILE(clk, RegWrite, rs, rt, rfile_wn, rfile_rd1, rfile_rd2, wdata); 

    alu     ALU(Operation, rfile_rd1, alu_b, shamt, alu_out, Zero);

    rom32_4 #(coreID) IMEM(pc, instr);

    mem32   #(coreID) DMEM(clk, MemRead, MemWrite, alu_out, rfile_rd2, dmem_rdata);

    and     BR_AND(PCSrc, Branch, Zero);

    mux2 #(5)   RFMUX(RegDst, rt, rd, rfile_wn);

    mux2 #(32)  PCMUX(PCSrc, pc_incr, b_tgt, pc_next);

    mux2 #(32) 	ALUMUX(ALUSrc, rfile_rd2, extend_immed, alu_b);

    mux2 #(32)  WRMUX(MemtoReg, alu_out, dmem_rdata, rfile_wd);


    // MIPS Controller
    control_single CTL(.opcode(opcode), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), 
                       .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), 
                       .ALUOp(ALUOp), .Halt(Halt));

    alu_ctl 	ALUCTL(ALUOp, funct, Operation);
    
    // Shared Memory Access Signal Generation
    assign sharedMEM = ALUSrc & |alu_out[21:7];
    
    always@ ( sharedMEM )
    begin
      if( sharedMEM == 1'b1 )
        $display("Core %2d: ALUSrc= %b & alu_out = %b", coreID, ALUSrc, alu_out);
    end
    
    // Data From/To Shared Memory 
    assign tosharedADDR = alu_out;
    assign tosharedDATA = rfile_rd2;
    assign tosharedRD = MemRead;
    assign tosharedWR = MemWrite;
    
    assign wdata = (sharedMEM)? fromsharedDATA : rfile_wd;
    
endmodule
