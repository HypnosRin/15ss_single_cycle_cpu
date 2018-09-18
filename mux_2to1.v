module mux_2to1 (
	in0,
	in1,
	out,
	sel
);

	parameter DWIDTH = 32;
	
	input [DWIDTH-1:0]	in0;
	input [DWIDTH-1:0]	in1;
	input 				sel;

	output [DWIDTH-1:0] out;

	assign out = (sel == 0) ? in0 : in1;

endmodule
