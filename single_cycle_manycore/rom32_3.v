//-----------------------------------------------------------------------------
// Title         : Read-Only Memory (Instruction ROM)
// Project       : ECE 313 - Computer Organization
//-----------------------------------------------------------------------------
// File          : rom32.v
// Author        : John Nestor  <nestorj@lafayette.edu>
// Organization  : Lafayette College
// 
// Created       : October 2002
// Last modified : 7 January 2005
//-----------------------------------------------------------------------------
// Description :
//   Behavioral model of a read-only memory used in the implementations of the MIPS
//   processor subset described in Ch. 5-6 of "Computer Organization and Design, 3rd ed."
//   by David Patterson & John Hennessey, Morgan Kaufmann, 2004 (COD3e).  
//
//   Note the use of the Verilog concatenation operator to specify different
//   instruction fields in each memory element.
//
//-----------------------------------------------------------------------------

module rom32_3(address, data_out);
  parameter coreID=0;

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
    if ((address % 4) != 0) $display($time, "Core %d: rom32 error: unaligned address %d", coreID, address);
    if (address_select == 1)
    begin
      (* full_case *) case (mem_offset) 
          5'd0 : data_out = { 6'd35, 5'd0, 5'd1, 16'd0 };              // lw $1, 0($0)   r1=1
          // ??? ???? ?? NOPs
          5'd1 : data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd2 : data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd3 : data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd4 : data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd5 : data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd6 : data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd7 : data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd8 : data_out = { 6'd35, 5'd0, 5'd3, 16'd128 };            // r3 <- SharedMEM[0] = 50
          5'd9 : data_out = { 6'd35, 5'd0, 5'd2, 16'd136 };            // r2 <- SharedMEM[2] = 75
          5'd10: data_out = { 6'd0,  5'd2, 5'd1, 5'd2, 5'd0, 6'd34 };  // add $2, $2, #1  r2 = r2 - r1
          5'd11: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd12: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd13: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          
          // 26 + 27 + ... + 50
          5'd14: data_out = { 6'd0,  5'd0, 5'd0, 5'd5, 5'd0, 6'd32 };  // add $5, $0, $0  r5 = 0
          5'd15: data_out = { 6'd0,  5'd3, 5'd1, 5'd3, 5'd0, 6'd32 };  // add $3, $3, #1  r3 = r3 + r1
          5'd16: data_out = { 6'd0,  5'd3, 5'd5, 5'd5, 5'd0, 6'd32 };  // add $5, $5, $3  r5 = r5 + r3
          5'd17: data_out = { 6'd0,  5'd2, 5'd3, 5'd6, 5'd0, 6'd42 };  // slt $6, $2, $3  if r2 < r3 ?
          5'd18: data_out = { 6'd4,  5'd6, 5'd0, -16'd4 };             // beq $6, $0, -4  if not, go back 3     
          5'd19: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP

          //
          5'd20: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd21: data_out = { 6'd43, 5'd0, 5'd5, 16'd148 };            // ?? ?? 
          5'd22: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd23: data_out = { 6'd63, 5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // HALT
          5'd24: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd25: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd26: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd27: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd28: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd29: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          5'd30: data_out = { 6'd0,  5'd0, 5'd0, 5'd30, 5'd0, 6'd32 }; // r30 = 0 : NOP
          // add more cases here as desired
          default data_out = 32'hffff;
      endcase
      $display($time, "Core %d: reading data: rom32[%h(%d)] => %h (%d)", coreID, address, address, data_out, data_out);
    end
  end 
endmodule