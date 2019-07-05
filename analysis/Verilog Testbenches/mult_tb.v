`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:17:59 01/11/2019
// Design Name:   multiplier_18x18
// Module Name:   C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/mult_tb.v
// Project Name:  HPF_tests
// Target Device:  
// Tool versions:  
// Description: testing the multiplier with the real indices used to prove that it's working as expected (it is!)
//
// Verilog Test Fixture created by ISE for module: multiplier_18x18
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
// Author: Stefano Buccelli @ IIT
////////////////////////////////////////////////////////////////////////////////

module mult_tb;

	// Inputs
	reg clk;
	reg [17:0] a;
	reg [17:0] b;
	reg [15:0] real_a;
	reg [15:0] real_b;

	// Outputs
	wire [35:0] p;
	reg [31:0] real_p; 

	// Instantiate the Unit Under Test (UUT)
	multiplier_18x18 uut (
		.clk(clk), 
		.a(a), 
		.b(b), 
		.p(p)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
   
	always
		#5 clk  =  ! clk ;
		
	always @(posedge clk) begin
		a=40;
		b=-20;
		real_a=a[17:2]; // the real multiplier_in
		real_b=b[16:1]; // the real HPF coefficient
		real_p=p[34:3]; // the real result: i.e. multiplier_out
	
	end
endmodule

