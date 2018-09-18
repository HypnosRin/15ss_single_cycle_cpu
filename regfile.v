module regfile (
	clk,
	raddr0,
	raddr1,
	rdata0,
	rdata1,
	waddr,
	wdata,
	wren
);

	input 			clk;
	input [4:0]		raddr0;
	input [4:0]		raddr1;
	input [4:0]		waddr;
	input [31:0]	wdata;
	input 			wren;

	output [31:0] 	rdata0;
	output [31:0] 	rdata1;

	reg [31:0] regfile [31:0];
	
	assign rdata0 = regfile[raddr0];
	assign rdata1 = regfile[raddr1];

	integer i;

	initial
	begin
		for (i = 0; i < 32; i = i + 1)
		begin
			regfile[i] = 0;
		end
	end

	always @(posedge clk)
	begin
		if (wren)
		begin
			regfile[waddr] <= wdata;
		end
	end
endmodule
