`timescale 1ns/1ps
module pipo_shift_tb;

reg   [15:0]   data_in;
reg            load, clk, reset;
reg   [1:0]    shift_en;
wire  [15:0]   data_out;

pipo_shift dut(
    .data_in   (data_in),
    .load      (load),
    .shift_en  (shift_en),
    .clk       (clk),
    .reset     (reset),
    .data_out  (data_out)
);
initial begin
    $dumpfile("pipo_shift.vcd");  // VCD output file name
    $dumpvars(0, pipo_shift_tb);  // Dump all variables in testbench
end
initial begin
    clk = 0;
    reset = 1;
    #5 reset = 0;
    forever #1 clk = ~clk; // fast clock: period = 2 units
end

initial begin 
    data_in   = 16'b1000111000010110;
    load      = 0;
    shift_en  = 2'b00;
    #10 load      = 1; // load data
    #2  shift_en  = 2'b00; // shift left
    #2  shift_en  = 2'b01; // shift right
    #2  shift_en  = 2'b10; // arithmetic left shift
    #2  shift_en  = 2'b11; // arithmetic right shift
    #50 $finish;
end

endmodule
