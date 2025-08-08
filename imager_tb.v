`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:34:44 04/21/2025
// Design Name:   image_scalar
// Module Name:   imager_tb.v
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

`module imager_scaler_tb_v;

    reg [7:0] T1, T2, T3, T4, B1, B2, B3, B4;
    reg clk;
    wire [7:0] Tpix;

    image_scalar uut (
        .T1(T1), .T2(T2), .T3(T3), .T4(T4),
        .B1(B1), .B2(B2), .B3(B3), .B4(B4),
        .clk(clk), .Tpix(Tpix)
    );

    reg [7:0] pixel_data [0:99999];
    integer outfile, i, pixel_count;

    initial begin
        clk = 0;
        $readmemh("output.hex", pixel_data);
        pixel_count = 0;
        while (pixel_data[pixel_count] !== 8'hxx && pixel_count < 100000)
            pixel_count = pixel_count + 1;

        $display("Loaded %0d pixels", pixel_count);

        outfile = $fopen("verilog_tpix_output.hex", "w");
        if (!outfile) begin
            $display("File open failed.");
            $finish;
        end

        for (i = 0; i + 7 < pixel_count; i = i + 1) begin
            T1 = pixel_data[i];
            T2 = pixel_data[i+1];
            T3 = pixel_data[i+2];
            T4 = pixel_data[i+3];
            B1 = pixel_data[i+4];
            B2 = pixel_data[i+5];
            B3 = pixel_data[i+6];
            B4 = pixel_data[i+7];
            #10;
            $fdisplay(outfile, "%02x", Tpix);
        end

        $fclose(outfile);
        $finish;
    end

    always #5 clk = ~clk;

endmodule
