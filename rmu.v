`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    10:19:29 03/07/25
// Design Name:    
// Module Name:    rmu
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
module rmu #(parameter WIDTH = 8) (
    input wire clk,
    input wire rst,
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire mode, // 0: Unsigned Multiplication, 1: Signed Multiplication
    output reg [2*WIDTH-1:0] result
);

    reg signed [WIDTH-1:0] signed_a, signed_b;
    reg [WIDTH-1:0] unsigned_a, unsigned_b;
    reg signed [2*WIDTH-1:0] signed_result;
    reg [2*WIDTH-1:0] unsigned_result;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
        end else begin
            if (mode) begin // Signed Multiplication
                signed_a = a;
                signed_b = b;
                signed_result = signed_a * signed_b;
                result = signed_result;
            end else begin // Unsigned Multiplication
                unsigned_a = a;
                unsigned_b = b;
                unsigned_result = unsigned_a * unsigned_b;
                result = unsigned_result;
            end
        end
    end

endmodule

