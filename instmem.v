module instmem (
	addr,
	inst
);

	input [31:0]	addr;

	output [31:0]	inst;

	reg [31:0]		instmem [255:0];

	initial
	begin
		$readmemh("prog.mips", instmem);
	end

	assign inst = instmem[addr[9:2]];

endmodule
