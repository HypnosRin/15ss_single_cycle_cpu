module ctrlunit (
	inst,
	datamem_wren,
	regfile_wren,
	regfile_dmux,
	regfile_rmux,
	alu_mux,
	alu_ctrl,
	alu_zero,
	pc_ctrl
);

	input [31:0]	inst;
	input 			alu_zero;
	
	output [3:0] 	datamem_wren;
	output 			regfile_wren;
	output 			regfile_dmux;
	output 			regfile_rmux;
	output 			alu_mux;
	output [3:0]	alu_ctrl;
	output [2:0]	pc_ctrl;

	reg [3:0]		datamem_wren;
	reg				regfile_wren;
	reg 			regfile_dmux;
	reg 			regfile_rmux;
	reg 			alu_mux;
	reg [3:0]		alu_ctrl;
	reg [2:0] 		pc_ctrl;

	reg [25:0]		addr;
	reg [5:0]		func;
	reg [15:0]		imm;
	reg [4:0]		rs;
	reg [4:0] 		rt;
	reg [4:0]		rd;
	reg [4:0] 		shift;
	reg [2:0]		type;

	wire [5:0]		op;

	assign op = inst[31:26];
	
	always @(inst)
	begin
		if (op == 6'b000000) // r
		begin
			addr 	= 26'b00000000000000000000000000;
			imm 	= 16'b0000000000000000;
			rs 		= inst[25:21];
			rt 		= inst[20:16];
			rd 		= inst[15:11];
		    shift	= inst[10:6];
			func 	= inst[5:0];
			type 	= 3'b001;
		end else if (op == 6'b000010 || op == 6'b000011) // j
		begin
			addr 	= inst[25:0];
			imm 	= 16'b0000000000000000;
			rs 		= 5'b00000;
			rt 		= 5'b00000;
			rd 		= 5'b00000;
			shift 	= 5'b00000;
			func 	= 6'b000000;
			type 	= 3'b100;
		end else // i
		begin
			addr 	= 26'b00000000000000000000000000;
			imm 	= inst[15:0];
			rs 		= inst[25:21];
			rt 		= inst[20:16];
			rd 		= 5'b00000;
			shift 	= inst[10:6];
			func 	= inst[5:0];
			type 	= 3'b010;
		end

		if (op == 6'b101011) // store word
		begin 
			datamem_wren = 4'b1111;
		end else // no write
		begin
			datamem_wren = 4'b0000;
		end

		if (op == 6'b000100 || op == 6'b000101 || op == 6'b000010 || op == 6'b000011 || (op == 6'b000000 && func == 6'b001000)) // branch
		begin
			regfile_wren = 0;
		end else
		begin
			regfile_wren = 1;
		end

		if (op == 6'b100011 || op == 6'b100101 || op == 6'b100000 || op == 6'b100100) // load word
		begin
			regfile_dmux = 0;
		end else
		begin
			regfile_dmux = 1;
		end

		if (op == 6'b000000) // r
		begin
			regfile_rmux = 1;
		end else // other
		begin
			regfile_rmux = 0;
		end

		if (!(op == 6'b000000 || op == 6'b000010 || op == 6'b000010)) // i
		begin
			alu_mux = 1;
		end else // r or j
		begin
			alu_mux = 0;
		end

		if ((op == 6'b000000 && func == 6'b101000) || op == 6'b001100) // and
		begin
			alu_ctrl = 4'b0000;
		end else 
		if ((op == 6'b000000 && func == 6'b100101) || op == 6'b001101) // or
		begin
			alu_ctrl = 4'b0001;
		end else
		if ((op == 6'b000000 && func == 6'b100001) || op == 6'b001001) // unsigned add
		begin
			alu_ctrl = 4'b0010;
		end else
		if  (op == 6'b000000 && func == 6'b100110) // xor
		begin
			alu_ctrl = 4'b0011;
		end else
		if  (op == 6'b000000 && func == 6'b100111) // nor
		begin
			alu_ctrl = 4'b0100;
		end else
		if  (op == 6'b000000 && func == 6'b100010) // unsigned sub
		begin
			alu_ctrl = 4'b0110;
		end else 
		if ((op == 6'b000000 && func == 6'b101010) || op == 6'b001010) // less than
		begin
			alu_ctrl = 4'b0111;
		end else
		if  (op == 6'b000000 && func == 6'b000000) // shl
		begin
			alu_ctrl = 4'b1000;
		end else
		if  (op == 6'b000000 && func == 6'b000010) // shr
		begin
			alu_ctrl = 4'b1001;
		end else
		if  (op == 6'b000000 && func == 6'b000011) // sra
		begin
			alu_ctrl = 4'b1010;
		end else
		if ((op == 6'b000000 && func == 6'b100000) || op == 6'b001000 || op == 6'b101011 || op == 6'b10001) // signed add
		begin
			alu_ctrl = 4'b1011;
		end else
		if ((op == 6'b000000 && func == 6'b100010) || op == 6'b000100 || op == 6'b000101) // signed sub
		begin
			alu_ctrl = 4'b1100;
		end else
		begin
			alu_ctrl = 4'b1111;
		end

		// maybe there will be a race condition
		#0.5 if (op == 6'b000010 || op == 6'b000011) // j, jal 
			 begin
			 	 pc_ctrl = 3'b001;
			 end else
			 if (op == 6'b000101 && func == 6'b001000) // jr
			 begin
			 	 pc_ctrl = 3'b010;
			 end else
			 if (op == 6'b000100 && alu_zero == 1) // beq
			 begin
				 pc_ctrl = 3'b011;
			 end else
			 if (op == 6'b000101 && alu_zero == 0) // bne
			 begin
				 pc_ctrl = 3'b011;
			 end else
			 begin
				 pc_ctrl = 3'b000;
			 end

		 end

endmodule

