//-----------------------------------------------------------------------------
// Title         : Register File (32 32-bit registers)
// Project       : ECE 313 - Computer Organization
//-----------------------------------------------------------------------------
// File          : reg_file.v
// Author        : John Nestor  <nestorj@lafayette.edu>
// Organization  : Lafayette College
// 
// Created       : October 2002
// Last modified : 7 January 2005
//-----------------------------------------------------------------------------
// Description :
//   Behavioral model of the register file  used in the implementations of the MIPS
//   processor subset described in Ch. 5-6 of "Computer Organization and Design, 3rd ed."
//   by David Patterson & John Hennessey, Morgan Kaufmann, 2004 (COD3e).  
//
//   It implements the function specified in Fig 5-7 on p. 295 of COD3e.
//
//-----------------------------------------------------------------------------

module reg_file(clk, RegWrite, RN1, RN2, WN, RD1, RD2, WD);
  parameter coreID=0;
  
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
    $display($time, "Core %d: reg_file[%d] => %d (Port 1)", coreID, RN1, RD1);
  end

  always @(RN2 or file_array[RN2])
  begin
    if (RN2 == 0) RD2 = 32'd0;
    else RD2 = file_array[RN2];
    $display($time, "Core %d: reg_file[%d] => %d (Port 2)", coreID, RN2, RD2);
  end

  always @(posedge clk) 
    if (RegWrite && (WN != 0))
    begin
      file_array[WN] <= WD;
      $display($time, "Core %d: reg_file[%d] <= %d (Write)", coreID, WN, WD);
    end
endmodule

