`timescale 1ns/1ps
module processor_tb;
    reg clk;
    reg reset;

    processor uut(.clk(clk), .reset(reset));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    initial begin
        $dumpfile("sim/processor.vcd");
        $dumpvars(0, processor_tb);
        reset = 1;
        #10 reset = 0;
        #300 $finish;
    end
endmodule