`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    21:41:35 02/03/25
// Design Name:    
// Module Name:    Isp
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module image_scalar (
    input [7:0] T1, T2, T3, T4, B1, B2, B3, B4,
    input clk,
    output reg [7:0] Tpix
);
    // First CSA stage: T3 + T2 + T4
    wire [7:0] sum_csa, carry_csa;
    carry_save_adder CSA1 (
        .a(T3), .b(T2), .c(T4),
        .sum(sum_csa), .carry(carry_csa)
    );
   reg [7:0] sum_csa_reg, carry_csa_reg;
    always @(posedge clk) begin
        sum_csa_reg <= sum_csa;
        carry_csa_reg <= carry_csa;
    end
    // Derivatives for edge detection
    wire signed [8:0] dx = $signed({1'b0, T3}) - $signed({1'b0, T1});
    wire signed [8:0] dy = $signed({1'b0, T4}) - $signed({1'b0, T2});

    reg signed [8:0] dx_reg, dy_reg;
    always @(posedge clk) begin
        dx_reg <= dx;
        dy_reg <= dy;
    end
    // Absolute max for sobel-like detection
    wire [8:0] abs_dx = dx_reg[8] ? -dx_reg : dx_reg;
    wire [8:0] abs_dy = dy_reg[8] ? -dy_reg : dy_reg;
    wire [8:0] temp_i = (abs_dx > abs_dy) ? abs_dx : abs_dy;
    reg [8:0] temp_i_reg;
    always @(posedge clk) begin
        temp_i_reg <= temp_i;
    end
    // Multiply sum_csa and carry_csa using Booth multiplier
    wire [15:0] mult_result;
    booth_multiplier BM1 (
        .A(sum_csa_reg),
        .B(carry_csa_reg),
		  .clk(clk),
        .product(mult_result)
    );
    reg [15:0] mult_result_reg;
    always @(posedge clk) begin
        mult_result_reg <= mult_result;
    end
    // Final CSA: compress mult_result and temp_i
    wire [7:0] final_sum, final_carry;
    carry_save_adder CSA2 (
        .a(mult_result_reg[7:0]),
        .b(mult_result_reg[15:8]),
        .c(temp_i_reg[7:0]),
        .sum(final_sum),
        .carry(final_carry)
    );
    reg [7:0] final_sum_reg, final_carry_reg;
    always @(posedge clk) begin
        final_sum_reg <= final_sum;
        final_carry_reg <= final_carry;
    end
    // Overflow-safe pixel value selection
    wire [8:0] temp_pix_raw = (abs_dx > abs_dy) ? {1'b0, final_carry_reg} : {1'b0, final_sum_reg};
    wire [7:0] clamped_pix = (temp_pix_raw > 9'd255) ? 8'd255 : temp_pix_raw[7:0];
    // Output pixel registered
    always @(posedge clk) begin
        Tpix <= clamped_pix;
    end

endmodule
