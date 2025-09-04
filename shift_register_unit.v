module pipo_shift_reg(
    input  wire [15:0] data_in,        // 16-bit input data
    input  wire        load_en,        // Load enable signal
    input  wire [1:0]  shift_mode,     // Shift operation selection
    input  wire        clk,            // Clock signal
    input  wire        rst_n,          // Active-low reset
    output reg  [15:0] data_out        // 16-bit output data
);

// Internal register for data storage
reg [15:0] shift_reg;

// Shift operations with clock synchronization
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition - clear all registers
        shift_reg <= 16'h0000;
        data_out  <= 16'h0000;
    end else begin
        if (load_en) begin
            // Load new data into shift register
            shift_reg <= data_in;
        end
        
        // Perform selected shift operation
        case (shift_mode)
            2'b00: begin    // Logical left shift
                shift_reg <= {shift_reg[14:0], 1'b0};
                data_out  <= {shift_reg[14:0], 1'b0};
            end
            2'b01: begin    // Logical right shift
                shift_reg <= {1'b0, shift_reg[15:1]};
                data_out  <= {1'b0, shift_reg[15:1]};
            end
            2'b10: begin    // Arithmetic left shift
                shift_reg <= {shift_reg[14:0], 1'b0};
                data_out  <= {shift_reg[14:0], 1'b0};
            end
            2'b11: begin    // Arithmetic right shift (preserves sign)
                shift_reg <= {shift_reg[15], shift_reg[15:1]};
                data_out  <= {shift_reg[15], shift_reg[15:1]};
            end
        endcase
    end
end

endmodule