module sharedMemArbiter (addr1, data1, rd1, wd1, sbit1,
                         addr2, data2, rd2, wd2, sbit2,
                         addr3, data3, rd3, wd3, sbit3,
                         addr4, data4, rd4, wd4, sbit4,
                         addr, data, rd, wd, sharedAccess);

  input [31:0] addr1;
  input [31:0] data1;
  input rd1, wd1, sbit1;

  input [31:0] addr2;
  input [31:0] data2;
  input rd2, wd2, sbit2;

  input [31:0] addr3;
  input [31:0] data3;
  input rd3, wd3, sbit3;

  input [31:0] addr4;
  input [31:0] data4;
  input rd4, wd4, sbit4;
  
  output [31:0] addr;
  output [31:0] data;
  output rd, wd;
  output sharedAccess;

  reg [31:0] addr;
  reg [31:0] data;
  reg rd, wd;
  
  // Default connection is Core2-MEM
  always @(*)
  begin
    case ( {sbit1, sbit2, sbit3, sbit4} )
      4'b1000 : begin 
        addr[6:0] = addr1[6:0];
        data = data1;
        rd = rd1; wd = wd1;
      end
      4'b0100 : begin
        addr[6:0] = addr2[6:0];
        data = data2;
        rd = rd2; wd = wd2;
      end
      4'b0010 : begin
        addr[6:0] = addr3[6:0];
        data = data3;
        rd = rd3; wd = wd3;        
      end
      4'b0001 : begin
        addr[6:0] = addr4[6:0];
        data = data4;
        rd = rd4; wd = wd4;        
      end
      default : begin
        addr[6:0] = addr4[6:0];
        data = data4;
        rd = rd4; wd = wd4;        
      end                        
    endcase
    
    addr[31:7] = 25'd0;
  end

  assign sharedAccess = sbit1 | sbit2 | sbit3 | sbit4;
  
endmodule
