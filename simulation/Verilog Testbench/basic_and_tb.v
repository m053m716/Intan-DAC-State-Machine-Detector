`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:43:52 01/10/2019
// Design Name:   basic_and
// Module Name:   C:/Users/BuccelliLab/Desktop/Prova_intan/HPF_tests/basic_and_tb.v
// Project Name:  HPF_tests
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: basic_and
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module basic_and_tb();
 
  reg [3:0] a, b;
  wire [3:0] out;
 
  basic_and #(.WIDTH(4)) DUT (
    .a(a),
    .b(b),
    .out(out)
  );
 
  initial begin
    a = 4'b0000;
    b = 4'b0000;
    #20
    a = 4'b1111;
    b = 4'b0101;
    #20
    a = 4'b1100;
    b = 4'b1111;
    #20
    a = 4'b1100;
    b = 4'b0011;
    #20
    a = 4'b1100;
    b = 4'b1010;
    #20
    $finish;
  end
 
endmodule

