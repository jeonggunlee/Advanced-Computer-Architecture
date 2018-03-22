## Single Cycle MIPS Source Code

다음 Verilog Code는 32-bit 덧셈기를 구현하고 있습니다. 아주 간단하죠 ?
덧셈이 일어나는 부분이 ```assign result = a + b``` 문장으로 구현되고 있습니다.
덧셈기를 만들기 위해서 전가산기 또는 반가산기 등의 회로가 필요없습니다.
그저 덧셈기가 하는 기능을 기술만 하면 됩니다. 기능만을 기술함으로써 회로를 설계하는 것!
이것이 바로 **행위수준 모델링 (Behavioral Modelling)**이죠.

게다가 유익한 것은 비트 크기 값을 바꿈으로써 쉽게 덧셈기의 크기를 바꿀수 있습니다.
```verilog
module add32(a, b, result);
  input [31:0] a, b;
  output [31:0] result;

  assign result = a + b;
endmodule
```

만약 32비트 덧셈기가 아니라 16비트 덧셈기가 필요하다면, 위의 코드에서 데이터의 크기(32 -> 16) 만을 변경해주면 될 것입니다.
```verilog
module add16(a, b, result);
  input [15:0] a, b;
  output [15:0] result;

  assign result = a + b;
endmodule
```

이러한 변경가능한 파라미터를 좀더 쉽게 기술하기 위하여 ```parameter```라는 키워드를 사용할 수 있습니다.
```verilog
module add(a, b, result);
  parameter bitwidth=32;
  input [15:0] a, b;
  output [15:0] result;

  assign result = a + b;
endmodule
```

위와 같이 기술한 경우 디폴트로 32비트 덧셈기가 되며, 만약 16비트 덧셈기가 필요한 경우 다음과 같이 instance를 생성하면됩니다.

```verilog
add (16) myadder(a, b, c);
```

위의 덧셈기 ```myadder```는 16비트 덧셈기로 생성됩니다. ```add```라는 하드웨어 타입과 실제 만들어지는 instance인 ```myadder```의 사이에 위치한 ```(16)```은 ```add``` 설계 내부의 ```parameter``` 값으로 전달되어 ```bitwidth``` 값이 default 값이 32에서 16으로 변경되도록 만듭니다.

```assign```은 **dataflow modelling**에 사용되는데, 일중의 기능중심의 행위수준 모델링 이라고 볼 수 있겠습니다.

다음 코드는 2 to 1 Mux 회로를 기술하고 있습니다.

```verilog
module mux2( sel, a, b, y );
    parameter bitwidth=32;
    input sel;
    input  [bitwidth-1:0] a, b;
    output [bitwidth-1:0] y;

    assign y = sel ? b : a;
endmodule
```

```verilog
module reg32 (clk, reset, d_in, d_out);
    input       	clk, reset;
    input	[31:0]	d_in;
    output 	[31:0] 	d_out;
    reg 	[31:0]	 d_out;
   
    always @(posedge clk)
    begin
        if (reset) d_out <= 0;
        else d_out <= d_in;
    end
endmodule
```

```verilog
module alu(ctl, a, b, result, zero);
  input [2:0] ctl;
  input [31:0] a, b;
  output [31:0] result;
  output zero;

  reg [31:0] result;
  reg zero;

  always @(a or b or ctl)
  begin
    case (ctl)
      3'b000 : result = a & b; // AND
      3'b001 : result = a | b; // OR
      3'b010 : result = a + b; // ADD
      3'b110 : result = a - b; // SUBTRACT
      3'b111 : if (a < b) result = 32'd1; 
               else result = 32'd0; //SLT      
      default : result = 32'hxxxxxxxx;
   endcase
   if (result == 32'd0) zero = 1;
   else zero = 0;
 end
endmodule
```


```verilog
module alu_ctl(ALUOp, Funct, ALUOperation);
    input [1:0] ALUOp;
    input [5:0] Funct;
    output [2:0] ALUOperation;
    reg    [2:0] ALUOperation;

    // symbolic constants for instruction function code
    parameter F_add = 6'd32;
    parameter F_sub = 6'd34;
    parameter F_and = 6'd36;
    parameter F_or  = 6'd37;
    parameter F_slt = 6'd42;

    // symbolic constants for ALU Operations
    parameter ALU_add = 3'b010;
    parameter ALU_sub = 3'b110;
    parameter ALU_and = 3'b000;
    parameter ALU_or  = 3'b001;
    parameter ALU_slt = 3'b111;

    always @(ALUOp or Funct)
    begin
        case (ALUOp) 
            2'b00 : ALUOperation = ALU_add;
            2'b01 : ALUOperation = ALU_sub;
            2'b10 : case (Funct) 
                        F_add : ALUOperation = ALU_add;
                        F_sub : ALUOperation = ALU_sub;
                        F_and : ALUOperation = ALU_and;
                        F_or  : ALUOperation = ALU_or;
                        F_slt : ALUOperation = ALU_slt;
                        default ALUOperation = 3'bxxx;
                    endcase
            default ALUOperation = 3'bxxx;
        endcase
    end
endmodule
```


```verilog
module alu_ctl(ALUOp, Funct, ALUOperation);
    input [1:0] ALUOp;
    input [5:0] Funct;
    output [2:0] ALUOperation;
    reg    [2:0] ALUOperation;

    // symbolic constants for instruction function code
    parameter F_add = 6'd32;
    parameter F_sub = 6'd34;
    parameter F_and = 6'd36;
    parameter F_or  = 6'd37;
    parameter F_slt = 6'd42;

    // symbolic constants for ALU Operations
    parameter ALU_add = 3'b010;
    parameter ALU_sub = 3'b110;
    parameter ALU_and = 3'b000;
    parameter ALU_or  = 3'b001;
    parameter ALU_slt = 3'b111;

    always @(ALUOp or Funct)
    begin
        case (ALUOp) 
            2'b00 : ALUOperation = ALU_add;
            2'b01 : ALUOperation = ALU_sub;
            2'b10 : case (Funct) 
                        F_add : ALUOperation = ALU_add;
                        F_sub : ALUOperation = ALU_sub;
                        F_and : ALUOperation = ALU_and;
                        F_or  : ALUOperation = ALU_or;
                        F_slt : ALUOperation = ALU_slt;
                        default ALUOperation = 3'bxxx;
                    endcase
            default ALUOperation = 3'bxxx;
        endcase
    end
endmodule
```


```verilog
module rom32(address, data_out);
  input  [31:0] address;
  output [31:0] data_out;
  reg    [31:0] data_out;

  parameter BASE_ADDRESS = 25'd0; // address that applies to this memory

  wire [4:0] mem_offset;
  wire address_select;

  assign mem_offset = address[6:2];  // drop 2 LSBs to get word offset

  assign address_select = (address[31:7] == BASE_ADDRESS);  // address decoding

  always @(address_select or mem_offset)
  begin
    if ((address % 4) != 0) $display($time, " rom32 error: unaligned address %d", address);
    if (address_select == 1)
    begin
      case (mem_offset) 
          5'd0 : data_out = { 6'd35, 5'd0, 5'd2, 16'd4 };             // lw $2, 4($0)    r2=1
          5'd1 : data_out = { 6'd35, 5'd0, 5'd3, 16'd8 };             // lw $3, 8($0)    r3=2
          5'd2 : data_out = { 6'd35, 5'd0, 5'd4, 16'd20 };            // lw $4, 20($0)  r4=5
          5'd3 : data_out = { 6'd0, 5'd0, 5'd0, 5'd5, 5'd0, 6'd32 };  // add $5, $0, $0  r5=0
          5'd4 : data_out = { 6'd0, 5'd5, 5'd2, 5'd5, 5'd0, 6'd32 };  // add $5, $5, $1  r5 = r6 + 1
          5'd5 : data_out = { 6'd0, 5'd4, 5'd5, 5'd6, 5'd0, 6'd42 };  // slt $6, $4, $5  is $5 > 54?
          5'd6 : data_out = { 6'd4, 5'd6, 5'd0, -16'd3 };             // beq $6, $zero, -3  if not, go back 2
          5'd7 : data_out = { 6'd43, 5'd0, 5'd5, 16'd0 };             // MEM[0] = $5
          // add more cases here as desired
          default data_out = 32'hxxxx;
      endcase
      $display($time, " reading data: rom32[%h] => %h", address, data_out);
    end
  end 
endmodule
```

```verilog
module mem32(clk, mem_read, mem_write, address, data_in, data_out);
  input  clk, mem_read, mem_write;
  input  [31:0] address, data_in;
  output [31:0] data_out;
  reg    [31:0] data_out;

  parameter BASE_ADDRESS = 25'd0; // address that applies to this memory - change if desired

  reg [31:0] mem_array [0:31];
  wire [4:0] mem_offset;
  wire address_select;

  assign mem_offset = address[6:2];  // drop 2 LSBs to get word offset

  assign address_select = (address[31:7] == BASE_ADDRESS);  // address decoding

  always @(mem_read or address_select or mem_offset or mem_array[mem_offset])
  begin

    if (mem_read == 1'b1 && address_select == 1'b1)
    begin
      if ((address % 4) != 0)
          $display($time, " rom32 error: unaligned address %d", address);
      data_out = mem_array[mem_offset];
      $display($time, " reading data: Mem[%h] => %h", address, data_out);
    end
      else data_out = 32'hxxxxxxxx;
  end

  // for WRITE operations
  always @(posedge clk)
  begin
    if (mem_write == 1'b1 && address_select == 1'b1)
    begin
      $display($time, " writing data: Mem[%h] <= %h", address,data_in);
      mem_array[mem_offset] <= data_in;
    end
  end

  // initialize with some arbitrary values

  integer i;
  initial begin
    for (i=0; i<7; i=i+1) mem_array[i] = i;
  end
endmodule
```


```verilog
module reg_file(clk, RegWrite, RN1, RN2, WN, RD1, RD2, WD);
  input clk;
  input RegWrite;
  input [4:0] RN1, RN2, WN;
  input [31:0] WD;
  output [31:0] RD1, RD2;

  reg [31:0] RD1, RD2;
  reg [31:0] file_array [31:1];

  always @(RN1 or file_array[RN1])
  begin   
    if (RN1 == 0) RD1 = 32'd0;
    else RD1 = file_array[RN1];
    $display($time, " reg_file[%d] => %d (Port 1)", RN1, RD1);
  end

  always @(RN2 or file_array[RN2])
  begin
    if (RN2 == 0) RD2 = 32'd0;
    else RD2 = file_array[RN2];
    $display($time, " reg_file[%d] => %d (Port 2)", RN2, RD2);
  end

  always @(posedge clk) 
    if (RegWrite && (WN != 0))
    begin
      file_array[WN] <= WD;
      $display($time, " reg_file[%d] <= %d (Write)", WN, WD);
    end
endmodule
```



```verilog
module control_single(opcode, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);
    input [5:0] opcode;
    output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
    output [1:0] ALUOp;
    reg    RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
    reg    [1:0] ALUOp;

    parameter R_FORMAT = 6'd0;
    parameter LW = 6'd35;
    parameter SW = 6'd43;
    parameter BEQ = 6'd4;

    always @(opcode)
    begin
        case (opcode)
          R_FORMAT : 
          begin
              RegDst=1'b1; ALUSrc=1'b0; MemtoReg=1'b0; RegWrite=1'b1; MemRead=1'b0; 
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'b10;
          end
          LW :
          begin
              RegDst=1'b0; ALUSrc=1'b1; MemtoReg=1'b1; RegWrite=1'b1; MemRead=1'b1; 
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'b00;
          end
          SW :
          begin
              RegDst=1'bx; ALUSrc=1'b1; MemtoReg=1'bx; RegWrite=1'b0; MemRead=1'b0; 
              MemWrite=1'b1; Branch=1'b0; ALUOp = 2'b00;
          end
          BEQ :
          begin
              RegDst=1'bx; ALUSrc=1'b0; MemtoReg=1'bx; RegWrite=1'b0; MemRead=1'b0; 
              MemWrite=1'b0; Branch=1'b1; ALUOp = 2'b01;
          end
          default
          begin
              $display("control_single unimplemented opcode %d", opcode);
              RegDst=1'bx; ALUSrc=1'bx; MemtoReg=1'bx; RegWrite=1'bx; MemRead=1'bx; 
              MemWrite=1'bx; Branch=1'bx; ALUOp = 2'bxx;
          end

        endcase
    end
endmodule
```

```verilog
module mips_single(clk, reset);
    input clk, reset;

    // instruction bus
    wire [31:0] instr;

    // break out important fields from instruction
    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [15:0] immed;
    wire [31:0] extend_immed, b_offset;
    wire [25:0] jumpoffset;

    assign opcode = instr[31:26];
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
    assign b_offset = extend_immed << 2;	// 주소의 단위는 4바이트

    // datapath signals
    wire [4:0] rfile_wn;
    wire [31:0] rfile_rd1, rfile_rd2, rfile_wd, alu_b, alu_out, b_tgt, pc_next,
                pc, pc_incr, br_add_out, dmem_rdata;
    
    // control signals

    wire RegWrite, Branch, PCSrc, RegDst, MemtoReg, MemRead, MemWrite, ALUSrc, Zero;
    wire [1:0] ALUOp;
    wire [2:0] Operation;

    // module instantiations

    reg32		PC(clk, reset, pc_next, pc);

    add32 		PCADD(pc, 32'd4, pc_incr);

    add32 		BRADD(pc_incr, b_offset, b_tgt);

    reg_file	RFILE(clk, RegWrite, rs, rt, rfile_wn, rfile_rd1, rfile_rd2, rfile_wd); 

    alu 		ALU(Operation, rfile_rd1, alu_b, alu_out, Zero);

    rom32 		IMEM(pc, instr);

    mem32 		DMEM(clk, MemRead, MemWrite, alu_out, rfile_rd2, dmem_rdata);

    and  		BR_AND(PCSrc, Branch, Zero);

    mux2 #(5) 	RFMUX(RegDst, rt, rd, rfile_wn);

    mux2 #(32)	PCMUX(PCSrc, pc_incr, b_tgt, pc_next);

    mux2 #(32) 	ALUMUX(ALUSrc, rfile_rd2, extend_immed, alu_b);

    mux2 #(32)	WRMUX(MemtoReg, alu_out, dmem_rdata, rfile_wd);

    control_single CTL(.opcode(opcode), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), 
                       .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), 
                       .ALUOp(ALUOp));

    alu_ctl 	ALUCTL(ALUOp, funct, Operation);
endmodule
```
