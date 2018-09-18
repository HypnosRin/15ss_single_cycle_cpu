module datamem (
	clk,
	addr,
	rdata,
	wdata,
	wren
);
	
	input 			clk;
	input [31:0] 	addr;
	input [31:0] 	wdata;
	input [3:0] 	wren;

	output [31:0]	rdata;

	reg [7:0]		mem_lane0 [65535:0];
	reg [7:0]		mem_lane1 [65535:0];
	reg [7:0]		mem_lane2 [65535:0];
	reg [7:0]		mem_lane3 [65535:0];

	assign rdata = {
		mem_lane3[addr[17:2]],
		mem_lane2[addr[17:2]],
		mem_lane1[addr[17:2]],
		mem_lane0[addr[17:2]]
		};
	
	always @(posedge clk)
	begin
		if (wren[0])
		begin
			mem_lane0[addr[17:2]] <= wdata[7:0];
		end
		if (wren[1])
		begin
			mem_lane1[addr[17:2]] <= wdata[15:8];
		end
		if (wren[2])
		begin
			mem_lane2[addr[17:2]] <= wdata[23:16];
		end
		if (wren[3])
		begin
			mem_lane3[addr[17:2]] <= wdata[31:24];
		end
	end

endmodule

