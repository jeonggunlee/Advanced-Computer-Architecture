# Advanced-Computer-Architecture

## Advanced Computer Architecture, 2018

**Teaching Staff**
  - Prof. Jeong-Gun Lee
  
**Time & Place**
  - Tuesday 6 PM.
  - 1219 Engineering Building.

Welcome to Advanced Computer Architecture. In this class, we learn an internal structure of a modern computer architecture and how to implement the architecture using Verilog HDL on an FPGA.

1. **Review of Computer Architecture** ([PPT](https://github.com/jeonggunlee/Advanced-Computer-Architecture/blob/master/PPTs/01_ACA_MIPS_SIMPLE_REVIEW.pptx))
    - MIPS Processor Architecture https://en.wikipedia.org/wiki/MIPS_architecture
    - Simple MIPS Instrucion Set
    - Single Cycle MIPS Processor
2. **[Verilog HDL](https://en.wikipedia.org/wiki/Verilog)([한글버전](https://ko.wikipedia.org/wiki/%EB%B2%A0%EB%A6%B4%EB%A1%9C%EA%B7%B8)), a Hardware Description Language (HDL)**
    - Class Note - [PPT](https://github.com/jeonggunlee/Advanced-Computer-Architecture/blob/master/PPTs/DDCA_Ch4.ppt)
    - Altera Verilog HDL Basic @ Youtube [LINK](https://www.youtube.com/watch?v=PJGvZSlsLKs)   
3. **Introduction to an FPGA and Logic Implementation on an FPGA (Intel FPGA Board)**
    - Intel Quartus II CAD Tool (Lite Edition for FREE) [Download Site](https://www.altera.com/downloads/download-center.html)
    - ModelSim Simulator
    - Combination Circuit Design: [Simple AND Gate Design & Test Bench](https://github.com/jeonggunlee/Advanced-Computer-Architecture/tree/master/SimpleDesignExam)
    - Combination Circuit Design: Switches & LEDs    
    - Sequential Circuit Design: [Counter & Digital Watch Design](https://github.com/jeonggunlee/Advanced-Computer-Architecture/blob/master/PPTs/digital_counter.pptx)
       - [7 Segment:S-5101ASR](https://www.devicemart.co.kr/11551)
       - [4-Digit 7-Segment:S-3461CSR](https://www.devicemart.co.kr/11544)
       - [LED Bar Movement Test Code] (https://github.com/jeonggunlee/Advanced-Computer-Architecture/blob/master/SimpleDesign2/ledmove.v)
       - [BCD to 7-Segment Convertor in Verilog](https://github.com/jeonggunlee/Advanced-Computer-Architecture/blob/master/SimpleDesign2/bcd2seven.v)
    - [DE0 Nano FPGA board](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=165&No=593&PartNo=1) will be used in this course. [Manual](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=165&No=593&PartNo=4)
4. **Design of a Single-Cycle MIPS Processor in Verilog HDL** ([Verilog Source](https://github.com/jeonggunlee/Advanced-Computer-Architecture/tree/master/single_cycle_mips))
    - Class Note [PPT](https://github.com/jeonggunlee/Advanced-Computer-Architecture/blob/master/PPTs/DDCA_Ch7.ppt)
5. **Design of Pipelined MIPS Processor**
6. **Design of Manycore MIPS Processor with Shared Memory** ([Verilog Source](https://github.com/jeonggunlee/Advanced-Computer-Architecture/tree/master/single_cycle_manycore))
    - Use a simplified shared memory.
    - Assume a compiler put a NOP to synchronize the operations among cores.
    - Simple arbitration scheme is used.
    - Synchronization and Data Communication via a Shared Memory.
7. **Design of Manycore MIPS Processor with On-Chip Network**



**Notice**
 - 26 Mar.: Please install Intel Quartus II Software Tool on your computer (laptop).
 - 20 Mar.: [Introduction to Git/Github: Hands on Lab_2018. 3. 31(Sat)(in Korean)](https://docs.google.com/forms/d/e/1FAIpQLSfOOPkLq3dBOY98yRz9qHggdRZH1G9oL1A4YowY2ov2ZoLb0w/viewform). If you have time, it will be good for you to learn how to use Git/Github.

* https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
