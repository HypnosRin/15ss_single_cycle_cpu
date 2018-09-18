module alu (
	operator,
	operand0,
	operand1,
	ret,
	overflow,
	zero
);
	input [3:0] 	operator;
	input [31:0] 	operand0;
	input [31:0]	operand1;

	output [31:0]	ret;
	output 			overflow;
	output			zero;

	reg [31:0] 		ret;
	reg  			overflow;
	reg 			zero;

	always @(operator)
	begin
		case (operator)
			4'b0000: // and
			begin
				ret 		= operand0 & operand1;
				overflow 	= 0;
				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b0001: // or
			begin
				ret 		= operand0 | operand1;
				overflow 	= 0;
				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b0010: // add
			begin
				ret 		= operand0 + operand1;
				overflow 	= 0;
				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b0011: // xor
			begin
				ret 		= operand0 ^ operand1;
				overflow 	= 0;
				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b0100: // nor
			begin
				ret 		= ~(operand0 | operand1);
				overflow 	= 0;
				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b0110: // sub
			begin
				ret 		= operand0 - operand1;
				overflow 	= 0;
				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b0111: // less than
			begin
				ret 		= (operand0 < operand1) ? -1 : 0;
				overflow 	= 0;
				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b1000: // shl
			begin
				ret 		= operand0 << operand1;
				overflow 	= 0;
				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b1001: // shr
			begin
				ret 		= operand0 >> operand1;
				overflow 	= 0;
				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b1010: // sra
			begin
				ret 		= operand0 >>> operand1;
				overflow 	= 0;
				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b1011: // signed add
			begin
				ret 		= operand0 + operand1;

				if ((operand0 >= 0 && operand1 >= 0 && ret < 0) || (operand0 < 0 && operand1 < 0 && ret >= 0))
				begin
					overflow = 1;
				end else 
				begin
					overflow = 0;
				end

				zero 		= (ret == 0) ? 1 : 0;
			end

			4'b1100: // signed sub
			begin
				ret 		= operand0 - operand1;

				if ((operand0 >= 0 && operand1 < 0 && ret < 0) || (operand0 < 0 && operand1 > 0 && ret >= 0))
				begin
					overflow = 1;
				end else
				begin
					overflow = 0;
				end

				zero 		= (ret == 0) ? 1 : 0;
			end

			default:
			begin
				zero 		= 0;
				overflow 	= 0;
			end

		endcase

	end
endmodule

