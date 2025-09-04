`timescale 1ns/1ps

module pipo_shift_reg_tb;

// Testbench signals
reg  [15:0] tb_data_in;
reg         tb_load_en;
reg  [1:0]  tb_shift_mode;
reg         tb_clk;
reg         tb_rst_n;
wire [15:0] tb_data_out;

// Instantiate the device under test
pipo_shift_reg dut (
    .data_in    (tb_data_in),
    .load_en    (tb_load_en),
    .shift_mode (tb_shift_mode),
    .clk        (tb_clk),
    .rst_n      (tb_rst_n),
    .data_out   (tb_data_out)
);

// Generate clock signal
initial begin
    tb_clk = 1'b0;
    forever #5 tb_clk = ~tb_clk; // 10ns period clock
end

// Initialize simulation and create waveform dump
initial begin
    $dumpfile("pipo_shift_reg.vcd");
    $dumpvars(0, pipo_shift_reg_tb);
end

// Main test sequence
initial begin
    // Initialize all inputs
    tb_data_in   = 16'h0000;
    tb_load_en   = 1'b0;
    tb_shift_mode = 2'b00;
    tb_rst_n     = 1'b0;  // Assert reset
    
    // Release reset after 20ns
    #20 tb_rst_n = 1'b1;
    
    // Test case 1: Load initial data
    #10;
    tb_data_in = 16'b1000111000010110; // Example test pattern
    tb_load_en = 1'b1;
    #10 tb_load_en = 1'b0;
    
    // Test case 2: Logical left shift
    #20;
    tb_shift_mode = 2'b00;
    #20;
    
    // Test case 3: Logical right shift
    tb_shift_mode = 2'b01;
    #20;
    
    // Test case 4: Arithmetic left shift
    tb_shift_mode = 2'b10;
    #20;
    
    // Test case 5: Arithmetic right shift
    tb_shift_mode = 2'b11;
    #20;
    
    // Test case 6: Load new data and verify shifts
    tb_data_in = 16'hF0F0;
    tb_load_en = 1'b1;
    #10 tb_load_en = 1'b0;
    
    // Perform all shift operations on new data
    tb_shift_mode = 2'b00; #20; // Left shift
    tb_shift_mode = 2'b01; #20; // Right shift
    tb_shift_mode = 2'b10; #20; // Arithmetic left
    tb_shift_mode = 2'b11; #20; // Arithmetic right
    
    // End simulation
    #50 $finish;
end

// Monitor to display results
initial begin
    $monitor("Time=%0t: data_in=%h, load_en=%b, shift_mode=%b, data_out=%h", 
             $time, tb_data_in, tb_load_en, tb_shift_mode, tb_data_out);
end

endmodule