`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:03:57 04/21/2025
// Design Name:   image_scalar
// Module Name:   im_tb.v
// Project Name:  image_scaler
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: image_scalar
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module im_tb_v;
 // Declare 8-bit registers for each input label
  reg [7:0] T1, T2, T3, T4, B1, B2, B3, B4;

  initial begin
    // Initialize from the contents of verilog_inputs.txt
  T1 = 8'd80;  // 0x50
T2 = 8'd96;  // 0x60
T3 = 8'd121;  // 0x79
T4 = 8'd144;  // 0x90
B1 = 8'd159;  // 0x9F
B2 = 8'd163;  // 0xA3
B3 = 8'd163;  // 0xA3
B4 = 8'd169;  // 0xA9

    // Display the values
    $display("T1 = %d", T1);
    $display("T2 = %d", T2);
    $display("T3 = %d", T3);
    $display("T4 = %d", T4);
    $display("B1 = %d", B1);
    $display("B2 = %d", B2);
    $display("B3 = %d", B3);
    $display("B4 = %d", B4);

    // Optionally: Add logic to drive a module with these inputs

    #10 $finish;  // End simulation
  end

endmodule