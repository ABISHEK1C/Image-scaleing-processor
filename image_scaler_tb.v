`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:21:37 04/21/2025
// Design Name:   image_scalar
// Module Name:   image_scaler_tb.v
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

module image_scaler_tb_v;


    // Inputs
    reg [7:0] B4, B3, B2, B1, B0, T1, T2, T3;
    
    // Output
    wire [7:0] Tpix;

    // File handle
    integer outfile;

    // Instantiate the Unit Under Test (UUT)
    image_scaler uut (
        .B4(B4),
        .B3(B3),
        .B2(B2),
        .B1(B1),
        .B0(B0),
        .T1(T1),
        .T2(T2),
        .T3(T3),
        .Tpix(Tpix)
    );

    initial begin
        // Initialize Inputs
        T1 = 8'h50;
        T2 = 8'h60;
        T3 = 8'h79;
        B4 = 8'h90;
        B3 = 8'h9F;
        B2 = 8'hA3;
        B1 = 8'hA3;
        B0 = 8'hA9;

        // Wait for initialization
        #100;

        // Open file
        outfile = $fopen("output.hex", "w");
        if (outfile == 0) begin
            $display("Failed to open output file.");
            $finish;
        end

        $fdisplay(outfile, "// Tpix Output");
        
        repeat (10) begin
            #10;
            $fdisplay(outfile, "%h", Tpix);
        end

        $fclose(outfile);
        $finish;
    end

endmodule
