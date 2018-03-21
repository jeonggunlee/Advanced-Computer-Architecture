## Single Cycle MIPS Source Code

The following code shows an adder design with the functional/behavioral description, "result = a + b".

```verilog
module add32(a, b, result);
  input [31:0] a, b;
  output [31:0] result;

  assign result = a + b;
endmodule
```

```assign``` is used for dataflow modelling.
