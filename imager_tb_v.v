`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:58:19 04/21/2025
// Design Name:   image_scalar
// Module Name:   imager_tb_v.v
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
module image_scalar_tb;

    reg clk;
    reg [7:0] T1, T2, T3, T4, B1, B2, B3, B4;
    wire [7:0] Tpix;

    integer i;
    integer file_out;
    integer width = 256, height = 256;
    reg [7:0] image_mem [0:65535];  // Holds image data
    integer row, col;

    // Instantiate the DUT
    image_scalar uut (
        .T1(T1), .T2(T2), .T3(T3), .T4(T4),
        .B1(B1), .B2(B2), .B3(B3), .B4(B4),
        .clk(clk),
        .Tpix(Tpix)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Function for safe pixel access
    function [7:0] safe;
        input integer idx;
        begin
            if (idx >= 0 && idx < width * height)
                safe = image_mem[idx];
            else
                safe = 8'd0;
        end
    endfunction

    initial begin
        clk = 0;
        $readmemh("panda_in.hex", image_mem);
        file_out = $fopen("panda_out.hex", "w");
        #10;

        for (i = 0; i < width * height; i = i + 1) begin
            row = i / width;
            col = i % width;

            if (row == 0 || row == height - 1 || col == 0 || col == width - 1) begin
                // Border pixels: replicate center
                T1 = safe(i); T2 = safe(i); T3 = safe(i); T4 = safe(i);
                B1 = safe(i); B2 = safe(i); B3 = safe(i); B4 = safe(i);
            end else begin
                T1 = safe(i - width - 1);  // top-left
                T2 = safe(i - width);      // top
                T3 = safe(i - width + 1);  // top-right
                T4 = safe(i - 1);          // left
                B1 = safe(i + 1);          // right
                B2 = safe(i + width - 1);  // bottom-left
                B3 = safe(i + width);      // bottom
                B4 = safe(i + width + 1);  // bottom-right
            end

            // Wait for pipeline delay (to let final output settle)
            repeat (10) @(posedge clk);

            // Write output pixel to file
            $fwrite(file_out, "%02x\n", Tpix);
        end

        $fclose(file_out);
        $display("? Simulation complete. Output written to panda_out.hex");
        $finish;
    end

endmodule
