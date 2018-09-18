module cpu (
	clk,
	rst
);

	input 		clk;
	input 		rst;

	wire [31:0] pc2addr;
	wire [31:0] inst;
	wire [31:0] inste;
	
	wire [3:0] 	signal_datamem_wren;
	wire 		signal_regfile_wren;
	wire 		signal_regfile_dmux;
	wire 		signal_regfile_rmux;
	wire 		signal_alu_mux;
	wire [3:0]	signal_alu_ctrl;
	wire [2:0] 	signal_pc_ctrl;

	wire [4:0] 	reg_waddr;

	wire [31:0]	reg_rdata0;
	wire [31:0]	reg_rdata1;
	wire [31:0]	reg_wdata;

	wire [31:0]	alu_operand1;

	wire [31:0] alu_res;

	wire 		alu_overflow;
	wire 		alu_zero;

	wire [31:0]	datamem_rdata;

	wire [4:0]	reg_radd0;
	wire [4:0]	reg_radd1;

	progcounter progcounter (
		.clk(clk),
		.rst(rst),
		.pc(pc2addr),
		.pc_ctrl(signal_pc_ctrl),
		.jmp_addr(inst[25:0]),
		.branch_offset(inst[15:0]),
		.reg_addr(reg_rdata0));

    sign_extension sige (
        .in(inst[15:0]),
        .out(inste));

	instmem instmem (
		.addr(pc2addr),
		.inst(inst));

	ctrlunit ctrlunit (
		.inst(inst),
		.datamem_wren(signal_datamem_wren),
		.regfile_wren(signal_regfile_wren),
		.regfile_dmux(signal_regfile_dmux),
		.regfile_rmux(signal_regfile_rmux),
		.alu_mux(signal_alu_mux),
		.alu_ctrl(signal_alu_ctrl),
		.alu_zero(alu_zero),
		.pc_ctrl(signal_pc_ctrl));


	assign reg_radd0 = inst[25:21];
	assign reg_radd1 = inst[20:16];

	mux_2to1 #(.DWIDTH(5)) instRegfileMux (
		.in0(reg_radd1),
		.in1(inst[15:11]),
		.out(reg_waddr),
		.sel(signal_regfile_rmux));

 	regfile regfile (
		.clk(clk),
		.raddr0(reg_radd0),
		.rdata0(reg_rdata0),
		.raddr1(reg_radd1),
		.rdata1(reg_rdata1),
		.waddr(reg_waddr),
		.wdata(reg_wdata),
		.wren(signal_regfile_wren));

	mux_2to1 aluOperand1Mux (
		.in0(reg_rdata1),	
		.in1(inste),
		.out(alu_operand1),
		.sel(signal_alu_mux));															

	alu alu(
		.operator(signal_alu_ctrl),
		.operand0(reg_rdata0),
		.operand1(alu_operand1),
		.ret(alu_res),
		.overflow(alu_overflow),
		.zero(alu_zero));

	mux_2to1 dataMemRData (
		.in0(datamem_rdata),
		.in1(alu_res),
		.out(reg_wdata),
		.sel(signal_regfile_dmux));

	datamem datamem (
		.clk(clk),
		.addr(alu_res),
		.rdata(datamem_rdata),
		.wdata(reg_rdata1),
		.wren(signal_datamem_wren));
		
endmodule
