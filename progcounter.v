module progcounter (
	clk,
	rst,
	pc,
	pc_ctrl,
	jmp_addr,
	branch_offset,
	reg_addr
);

	input				clk;
	input 				rst;
	input 		[2:0] 	pc_ctrl;
	input 		[25:0]	jmp_addr;
	input 		[15:0]	branch_offset;
	input 		[31:0] 	reg_addr;

	output reg 	[31:0] 	pc;

	wire 		[31:0] 	pc_incre_4;

	assign		pc_incre_4 = pc + 4;

	always @(posedge clk or posedge rst)
	begin
		if (rst)
		begin
			pc <= 32'b00000000000000000000000000000000;
		end else
		begin
			case (pc_ctrl)
				3'b000:  pc <= pc_incre_4;
				3'b001:  pc <= {
					pc_incre_4[31:28],
					jmp_addr,
					2'b00};
				3'b010:	 pc <= reg_addr;
				3'b011:  pc <= pc_incre_4 + {
					{14{branch_offset[15]}},
					branch_offset[15:0],
					2'b00};
				default: pc <= pc_incre_4;
			endcase
		end
	end

endmodule
